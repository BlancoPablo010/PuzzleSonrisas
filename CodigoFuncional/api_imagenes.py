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
    
    if not file_bytes:
        return jsonify({'error': 'No file data provided'}), 400  # Cambié el código de error a 400

    # Asegurarse de que el nombre del archivo tenga una extensión correcta
    if not filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        return jsonify({'error': 'Invalid file type'}), 400

    file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    
    with open(file_path, 'wb') as f:
        f.write(file_bytes)

    return jsonify({'message': 'Image uploaded successfully', 'file_path': file_path}), 201

if __name__ == '__main__':
    app.run(debug=True)