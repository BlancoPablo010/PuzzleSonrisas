import os
from bson import ObjectId
from flask import Flask, request, jsonify
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required
from pymongo import MongoClient
from datetime import timedelta
from flask_cors import CORS

app = Flask(__name__)

CORS(app)
app.config["JWT_SECRET_KEY"] = 'oHNQ*S3ASy=F!^|f11}||P~95v9w7KZFU'
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(hours=6)

connection_string = os.getenv('ACCOUNT_URI')
client = MongoClient(connection_string)
#create database
db = client["puzzle_sonrisas"]
#create collection
usuarios_collection = db["usuarios"]
tareas_collection = db["tareas"]
materiales_collection = db["materiales"]
peticiones_material_collection = db["peticiones_material"]


bcrypt = Bcrypt(app)
jwt = JWTManager(app)

# Register route
@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    if usuarios_collection.find_one({"usuario": data["usuario"]}):
        return jsonify({"error": "El usuario ya existe"}), 409

    hashed_password = bcrypt.generate_password_hash(data["password"]).decode("utf-8")
    user_data = {
        "usuario": data["usuario"],
        "password": hashed_password,
        "rol": data["rol"]  # 'Administrador', 'Alumno', 'Profesor'
    }
    
    usuarios_collection.insert_one(user_data)
    return jsonify({"message": "Usuario registrado con éxito"}), 201

# Login route
@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    user = usuarios_collection.find_one({"usuario": data["usuario"]})

    if user and bcrypt.check_password_hash(user["password"], data["password"]):
        access_token = create_access_token(identity=data["usuario"])
        return jsonify(access_token=access_token, rol=user["rol"], _id=str(user["_id"])), 200

    return jsonify({"error": "Credenciales inválidas"}), 401

@app.route("/loginAlumno", methods=["POST"])
def loginAlumno():
    data = request.get_json()
    user = usuarios_collection.find_one({"usuario": data["usuario"], "rol": "Alumno"})

    if user and (user["password"] == data["password"]):
        access_token = create_access_token(identity=data["usuario"])
        return jsonify(access_token=access_token, rol="Alumno", _id=str(user["_id"])), 200

    return jsonify({"error": "Credenciales inválidas"}), 401

@app.route("/alumno", methods=["POST"])
@jwt_required()
def create_alumno():
    data = request.get_json()
    if "usuario" not in data:
        return jsonify({"error": "Falta el campo 'usuario'"}), 400

    if "password" not in data:
        return jsonify({"error": "Falta el campo 'password'"}), 400
    
    user_data = {
        "usuario": data["usuario"],
        "password": data["password"],
        "rol": "Alumno",
        "nombre": data["nombre"],
        "apellidos": data["apellidos"],
        "preferencia": data["preferencia"],
        "tareas_asignadas": []
    }

    usuarios_collection.insert_one(user_data)
    return jsonify({"message": "Alumno creado con éxito"}), 201

@app.route("/alumnos", methods=["GET"])
@jwt_required()
def get_alumnos():
    usuarios_collection = db["usuarios"]
    # Encuentra todos los usuarios con el rol de "Alumno"
    alumnos = list(usuarios_collection.find({"rol": "Alumno"}))
    
    # Transforma los documentos a un formato JSON serializable
    for alumno in alumnos:
        alumno['_id'] = str(alumno['_id'])  # Convierte ObjectId a cadena
        alumno['tareas_asignadas'] = [str(tarea_id) for tarea_id in alumno['tareas_asignadas']]  # Convierte ObjectId de tareas a cadena
    
    return jsonify(alumnos), 200

@app.route("/password/<usuario>", methods=["GET"])
def get_password(usuario):
    user = usuarios_collection.find_one({"usuario": usuario})
    if not user:
        return jsonify({"error": "Usuario no encontrado"}), 404

    return jsonify({"password": user["password"]}), 200

@app.route("/alumnos/<usuario>", methods=["DELETE"])
@jwt_required()
def delete_alumno(usuario):
    result = usuarios_collection.delete_one({"usuario": usuario, "rol": "Alumno"})
    if result.deleted_count == 0:
        return jsonify({"error": "No se encontró el alumno"}), 404

    return jsonify({"message": "Alumno eliminado con éxito"}), 200


@app.route("/tarea", methods=["POST"])
@jwt_required()
def create_tarea():
    data = request.get_json()
    
    if "titulo" not in data or "numero_pasos" not in data or "pasos" not in data or "imagen_principal" not in data:
        return jsonify({"error": "Faltan campos requeridos"}), 400
    
    if data["numero_pasos"] != len(data["pasos"]):
        return jsonify({"error": "El número de pasos no coincide con la cantidad de elementos en 'pasos'"}), 400
    
    for paso in data["pasos"]:
        if "numero_paso" not in paso or "accion" not in paso or "imagen" not in paso:
            return jsonify({"error": "Cada paso debe contener 'numero_paso', 'accion', y 'imagen'"}), 400
            
    tarea = {
        "titulo": data["titulo"],
        "numero_pasos": data["numero_pasos"],
        "pasos": data["pasos"],
        "imagen_principal": data["imagen_principal"],
    }
    
    # Insertar la tarea en la base de datos
    tarea_id = tareas_collection.insert_one(tarea).inserted_id
    
    return jsonify({"message": "Tarea creada con éxito", "tarea_id": str(tarea_id)}), 201

@app.route("/tareas", methods=["GET"])
@jwt_required()
def get_tareas():
    tareas_collection = db["tareas"]
    tareas = list(tareas_collection.find()) 
    
    for tarea in tareas:
        tarea['_id'] = str(tarea['_id'])  
    
    return jsonify(list(tareas)), 200


# Delete a specific task
@app.route("/tareas/<id>", methods=["DELETE"])
@jwt_required()
def delete_tarea(id):
    result = tareas_collection.delete_one({"_id": ObjectId(id)})
    if result.deleted_count == 0:
        return jsonify({"error": "No se encontró la tarea"}), 404

    return jsonify({"message": "Tarea eliminada con éxito"}), 200

# Delete a specific task step
@app.route("/tarea/<tarea_id>/pasos/<numero_paso>", methods=["DELETE"])
@jwt_required()
def delete_paso(tarea_id, paso_numero):
    tareas_collection = db["tareas"]
    tarea = tareas_collection.find_one({"_id": tarea_id})
    if not tarea:
        return jsonify({"error": "No se encontró la tarea"}), 404

    paso = next((p for p in tarea["pasos"] if p["numero_paso"] == paso_numero), None)
    if not paso:
        return jsonify({"error": "No se encontró el paso"}), 404

    tarea["pasos"].remove(paso)
    tareas_collection.update_one({"_id": tarea_id}, {"$set": {"pasos": tarea["pasos"]}})
    return jsonify({"message": "Paso eliminado con éxito"}), 200

# Add a step to a specific task
@app.route("/tarea/<tarea_id>/pasos", methods=["POST"])
@jwt_required()
def add_paso(tarea_id, paso):

    tareas_collection = db["tareas"]
    tarea = tareas_collection.find_one({"_id": tarea_id})
    if not tarea:
        return jsonify({"error": "No se encontró la tarea"}), 404

    tarea["pasos"].append(paso)
    tareas_collection.update_one({"_id": tarea_id}, {"$set": {"pasos": tarea["pasos"]}})
    return jsonify({"message": "Paso añadido con éxito"}), 201

# Complete a specific task
@app.route("/tarea/<tarea_id>/completar", methods=["PUT"])
@jwt_required()
def completar_tarea(tarea_id):
    tareas_collection = db["tareas"]
    tarea = tareas_collection.find_one({"_id": tarea_id})
    if not tarea:
        return jsonify({"error": "No se encontró la tarea"}), 404

    tareas_collection.update_one({"_id": tarea_id}, {"$set": {"completada": True}})
    return jsonify({"message": "Tarea completada conmplétada con éxito"}), 200

# Add a deadline to a specific task
@app.route("/tarea/<tarea_id>/fecha_limite", methods=["PUT"])
@jwt_required()
def add_fecha_limite(tarea_id, fecha_limite):
    tareas_collection = db["tareas"]
    tarea = tareas_collection.find_one({"_id": tarea_id})
    if not tarea:
        return jsonify({"error": "No se encontró la tarea"}), 404

    tareas_collection.update_one({"_id": tarea_id}, {"$set": {"fecha_limite": fecha_limite}})
    return jsonify({"message": "Fecha límite añadida con éxito"}), 200

# Add a task to a specific student
@app.route("/alumno/<id_alumno>/asignar_tarea", methods=["POST"])
@jwt_required()
def add_tarea_alumno(id_alumno):
    data = request.get_json()
    if "id_tarea" not in data or "id_alumno" not in data:
        return jsonify({"error": "Faltan campos requeridos"}), 400
    id_tarea = data["id_tarea"]

    tareas_collection = db["tareas"]
    tarea = tareas_collection.find_one({"_id": ObjectId(id_tarea)})
    if not tarea:
        return jsonify({"error": "No se encontró la tarea"}), 404

    usuarios_collection.update_one({"_id": ObjectId(id_alumno), "rol": "Alumno"}, {"$push": {"tareas_asignadas": ObjectId(id_tarea)}})
    return jsonify({"message": "Tarea añadida con éxito"}), 200

# Delete a task from a specific student
@app.route("/alumno/<id_usuario>/desasignar_tarea", methods=["DELETE"])
@jwt_required()
def delete_tarea_alumno(id_usuario):

    data = request.get_json()
    if "id_tarea" not in data:
        return jsonify({"error": "Faltan campos requeridos"}), 400
    id_tarea = data["id_tarea"]
    usuarios_collection.update_one({"_id": ObjectId(id_usuario), "rol": "Alumno"}, {"$pull": {"tareas_asignadas": ObjectId(id_tarea)}})
    return jsonify({"message": "Tarea eliminada con éxito"}), 200

# Show the tasks of a specific student
@app.route("/alumno/<id>/tareas_asignadas", methods=["GET"])
@jwt_required()
def get_tareas_alumno(id):
    alumno = usuarios_collection.find_one({"_id": ObjectId(id), "rol": "Alumno"}, {"_id": 0, "password": 0})
    if not alumno:
        return jsonify({"error": "Alumno no encontrado"}), 404

    tareas_collection = db["tareas"]
    tareas = list(tareas_collection.find({"_id": {"$in": alumno["tareas_asignadas"]}}))

    for tarea in tareas:
        tarea['_id'] = str(tarea['_id'])

    return jsonify(list(tareas)), 200

#Update a task
@app.route("/tarea/<tarea_id>", methods=["PUT"])
@jwt_required()
def update_tarea(tarea_id):
    data = request.get_json()
    if not data:
        return jsonify({"error": "No se proporcionó ningún dato para actualizar"}), 400

    titulo = data.get("titulo")
    numero_pasos = data.get("numero_pasos")
    pasos = data.get("pasos")

    if not pasos and not titulo and not numero_pasos:
        return jsonify({"error": "Debe proporcionar al menos un campo para actualizar"}), 400

    # Construir el diccionario con los campos a actualizar
    update_fields = {}
    if titulo:
        update_fields["titulo"] = titulo
    if numero_pasos:
        update_fields["numero_pasos"] = numero_pasos
    if pasos:
        update_fields["pasos"] = pasos
    
    # Actualizar la tarea en la base de datos
    result = tareas_collection.update_one({"_id": ObjectId(tarea_id)}, {"$set": update_fields})

    if result.matched_count == 0:
        return jsonify({"error": "No se encontró la tarea"}), 404

    return jsonify({"message": "Tarea actualizada con éxito"}), 200

@app.route("/profesor", methods=["POST"])
@jwt_required()
def create_profesor():
    data = request.get_json()
    if "usuario" not in data:
        return jsonify({"error": "Falta el campo 'usuario'"}), 400

    if "password" not in data:
        return jsonify({"error": "Falta el campo 'password'"}), 400
    
    hashed_password = bcrypt.generate_password_hash(data["password"]).decode("utf-8")
    
    user_data = {
        "usuario": data["usuario"],
        "password": hashed_password,
        "rol": "Profesor",
        "nombre": data["nombre"],
        "apellidos": data["apellidos"]
    }

    usuarios_collection.insert_one(user_data)
    return jsonify({"message": "Profesor creado con éxito"}), 201

@app.route("/profesores", methods=["GET"])
@jwt_required()
def get_profesores():
    usuarios_collection = db["usuarios"]
    profesores = list(usuarios_collection.find({"rol": "Profesor"}))
    
    for profesor in profesores:
        profesor['_id'] = str(profesor['_id'])  
    
    return jsonify(profesores), 200

@app.route("/profesores/<id>", methods=["GET"])
@jwt_required()
def get_profesor(id):
    profesor = usuarios_collection.find_one({"_id": ObjectId(id), "rol": "Profesor"})
    if not profesor:
        return jsonify({"error": "No se encontró el profesor"}), 404

    profesor['_id'] = str(profesor['_id'])
    return jsonify(profesor), 200

@app.route("/profesores/<id>", methods=["DELETE"])
@jwt_required()
def delete_profesor(id):
    result = usuarios_collection.delete_one({"_id": ObjectId(id), "rol": "Profesor"})
    if result.deleted_count == 0:
        return jsonify({"error": "No se encontró el profesor"}), 404

    return jsonify({"message": "Profesor eliminado con éxito"}), 200


@app.route("/material", methods=["POST"])
@jwt_required()
def create_material():
    data = request.get_json()
    if "titulo" not in data or "imagen" not in data:
        return jsonify({"error": "Faltan campos requeridos"}), 400
    
    material = {
        "titulo": data["titulo"],
        "imagen": data["imagen"]
    }
    
    material_id = materiales_collection.insert_one(material).inserted_id
    
    return jsonify({"message": "Material creado con éxito", "material_id": str(material_id)}), 201

@app.route("/materiales", methods=["GET"])
@jwt_required()
def get_materiales():
    materiales = list(materiales_collection.find()) 
    
    for material in materiales:
        material['_id'] = str(material['_id'])  
    
    return jsonify(list(materiales)), 200

@app.route("/materiales/<id>", methods=["GET"])
@jwt_required()
def get_material(id):
    material = materiales_collection.find_one({"_id": ObjectId(id)})
    if not material:
        return jsonify({"error": "No se encontró el material"}), 404

    material['_id'] = str(material['_id'])
    return jsonify(material), 200

@app.route("/materiales/<id>", methods=["DELETE"])
@jwt_required()
def delete_material(id):
    result = materiales_collection.delete_one({"_id": ObjectId(id)})
    if result.deleted_count == 0:
        return jsonify({"error": "No se encontró el material"}), 404

    return jsonify({"message": "Material eliminado con éxito"}), 200

@app.route("/peticion_material", methods=["POST"])
@jwt_required()
def create_peticion():
    data = request.get_json()
    
    if "titulo" not in data or "materiales" not in data or "profesor" not in data or "fecha" not in data:
        return jsonify({"error": "Faltan campos requeridos"}), 400
    
    peticion_material = {
        "titulo": data["titulo"],
        "materiales": data["materiales"],
        "profesor": data["profesor"],
        "fecha": data["fecha"]
    }

    peticiones_material_collection.insert_one(peticion_material)
    
    return jsonify({'message': 'Peticion creada'}), 201

@app.route("/peticiones", methods=["GET"])
@jwt_required()
def get_peticiones():
    peticiones = list(peticiones_material_collection.find()) 
    
    for peticion in peticiones:
        peticion['_id'] = str(peticion['_id']) 
    
    return jsonify(list(peticiones)), 200

@app.route("/peticiones/<id>", methods=["DELETE"])
@jwt_required()
def delete_peticion(id):
    result = peticiones_material_collection.delete_one({"_id": ObjectId(id)})
    if result.deleted_count == 0:
        return jsonify({"error": "No se encontró la petición"}), 404

    return jsonify({"message": "Petición eliminada con éxito"}), 200

@app.route('/test', methods=['GET'])
def test():
    item = usuarios_collection.find_one({"name": "Peter"})
    return jsonify({ "item": item["name"] })

if __name__ == '__main__':
    app.run(debug=True)
