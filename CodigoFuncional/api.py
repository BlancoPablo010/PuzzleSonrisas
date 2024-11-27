import os
from flask import Flask, request, jsonify
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required
from pymongo import MongoClient
from datetime import timedelta
from flask_cors import CORS
import base64


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
        return jsonify(access_token=access_token, rol="Administrador"), 200

    return jsonify({"error": "Credenciales inválidas"}), 401

@app.route("/loginAlumno", methods=["POST"])
def loginAlumno():
    data = request.get_json()
    user = usuarios_collection.find_one({"usuario": data["usuario"], "rol": "Alumno"})

    if user and (user["password"] == data["password"]):
        access_token = create_access_token(identity=data["usuario"])
        return jsonify(access_token=access_token, rol="Alumno"), 200

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
        "discapacidad": data["discapacidad"],
        "tareas_asignadas": []
    }

    usuarios_collection.insert_one(user_data)
    return jsonify({"message": "Alumno creado con éxito"}), 201

@app.route("/alumnos", methods=["GET"])
@jwt_required()
def get_alumnos():
    alumnos = usuarios_collection.find({"rol": "Alumno"}, {"_id": 0, "password": 0})
    return jsonify(list(alumnos)), 200

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
    
    if "titulo" not in data or "numero_pasos" not in data or "pasos" not in data:
        return jsonify({"error": "Faltan campos requeridos"}), 400
    
    if data["numero_pasos"] != len(data["pasos"]):
        return jsonify({"error": "El número de pasos no coincide con la cantidad de elementos en 'pasos'"}), 400
    
    for paso in data["pasos"]:
        if "numero_paso" not in paso or "accion" not in paso or "imagen" not in paso:
            return jsonify({"error": "Cada paso debe contener 'numero_paso', 'accion', y 'imagen'"}), 400
        
        if isinstance(paso["imagen"], str):
            paso["imagen"] = base64.b64decode(paso["imagen"]) 
            
            
    tarea = {
        "titulo": data["titulo"],
        "numero_pasos": data["numero_pasos"],
        "pasos": data["pasos"]
    }
    
    # Insertar la tarea en la base de datos
    tarea_id = tareas_collection.insert_one(tarea).inserted_id
    
    return jsonify({"message": "Tarea creada con éxito", "tarea_id": str(tarea_id)}), 201

@app.route("/tareas", methods=["GET"])
@jwt_required()
def get_tareas():
    tareas_collection = db["tareas"]
    tareas = tareas_collection.find({}, {"_id": 0})
    return jsonify(list(tareas)), 200

# Delete a specific task
@app.route("/tareas/<titulo>", methods=["DELETE"])
@jwt_required()
def delete_tarea(titulo):
    result = tareas_collection.delete_one({"titulo": titulo})
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
@app.route("/alumno/<usuario>/tareas_asignadas", methods=["POST"])
@jwt_required()
def add_tarea_alumno(usuario, tarea_id):
    tareas_collection = db["tareas"]
    tarea = tareas_collection.find_one({"_id": tarea_id})
    if not tarea:
        return jsonify({"error": "No se encontró la tarea"}), 404

    usuarios_collection.update_one({"usuario": usuario, "rol": "Alumno"}, {"$push": {"tareas_asignadas": tarea_id}})
    return jsonify({"message": "Tarea añadida con éxito"}), 200

# Delete a task from a specific student
@app.route("/alumno/<usuario>/tarea/<tarea_id>", methods=["DELETE"])
@jwt_required()
def delete_tarea_alumno(usuario, tarea_id):
    usuarios_collection.update_one({"usuario": usuario, "rol": "Alumno"}, {"$pull": {"tareas_asignadas": tarea_id}})
    return jsonify({"message": "Tarea eliminada con éxito"}), 200

# Show the tasks of a specific student
@app.route("/alumno/<usuario>/tareas_asignadas", methods=["GET"])
@jwt_required()
def get_tareas_alumno(usuario):
    alumno = usuarios_collection.find_one({"usuario": usuario, "rol": "Alumno"}, {"_id": 0, "password": 0})
    if not alumno:
        return jsonify({"error": "Alumno no encontrado"}), 404

    tareas_collection = db["tareas"]
    tareas = tareas_collection.find({"_id": {"$in": alumno["tareas_asignadas"]}}, {"_id": 0})
    return jsonify(list(tareas)), 200

#Update a task
@app.route("/tarea/<tarea_id>", methods=["PUT"])
@jwt_required()
def update_tarea(tarea_id):
    data = request.get_json()
    if not data:
        return jsonify({"error": "No se proporcionó ningún dato para actualizar"}), 400

    pasos = data.get("pasos")
    if not pasos:
        return jsonify({"error": "Los pasos son obligatorios"}), 400

    result = tareas_collection.update_one({"_id": tarea_id}, {"$set": {"pasos": pasos}})

    if result.matched_count == 0:
        return jsonify({"error": "No se encontró la tarea"}), 404

    return jsonify({"message": "Tarea actualizada con éxito"}), 200

@app.route('/test', methods=['GET'])
def test():
    item = usuarios_collection.find_one({"name": "Peter"})
    return jsonify({ "item": item["name"] })

if __name__ == '__main__':
    app.run(debug=True)
