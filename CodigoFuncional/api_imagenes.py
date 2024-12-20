from flask import Flask, request, jsonify
from flask_cors import CORS 
import os

app = Flask(__name__)
CORS(app)

# Define la carpeta donde se guardarán las imágenes
UPLOAD_FOLDER = 'img'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Asegúrate de que la carpeta exista
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_image():
    file_bytes = request.data
    filename = request.headers.get('X-File-Name', 'uploaded_image.png') 
    
    # Asegurarse de que se haya proporcionado algún dato de archivo
    if not file_bytes:
        return jsonify({'error': 'No file data provided'}), 404

    # Asegurarse de que el nombre del archivo tenga una extensión correcta
    if not filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        return jsonify({'error': 'Invalid file type'}), 403

    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    
    # Guardar la imagen en el sistema de archivos
    with open(file_path, 'wb') as f:
        f.write(file_bytes)

    # Devolver una respuesta exitosa
    return jsonify({'message': 'Image uploaded successfully', 'file_path': file_path}), 201

@app.route('/delete', methods=['DELETE'])
def delete_image():
    filename = request.headers.get('X-File-Name', 'uploaded_image.png')
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)

    # Asegurarse de que el archivo exista
    if not os.path.exists(file_path):
        return jsonify({'error': 'File not found'}), 404

    # Eliminar el archivo del sistema de archivos
    os.remove(file_path)

    # Devolver una respuesta exitosa
    return jsonify({'message': 'Image deleted successfully', 'file_path': file_path}), 200

if __name__ == '__main__':
    app.run(debug=True)