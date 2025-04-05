import os
from flask import Flask, jsonify
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)

# Configuration
app.config['ENV'] = os.getenv('FLASK_ENV', 'production')
app.config['DEBUG'] = os.getenv('FLASK_ENV', 'production') == 'development'

# Health check endpoint
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'UP',
        'message': 'Service is running'
    }), 200

# API routes
@app.route('/api', methods=['GET'])
def api_info():
    return jsonify({
        'message': 'Welcome to the Startup Incubator API',
        'version': '1.0.0',
        'documentation': '/api/docs'
    }), 200

@app.route('/api/docs', methods=['GET'])
def api_docs():
    return jsonify({
        'message': 'API Documentation',
        'endpoints': [
            {'path': '/api', 'method': 'GET', 'description': 'API information'},
            {'path': '/api/docs', 'method': 'GET', 'description': 'API documentation'},
            {'path': '/health', 'method': 'GET', 'description': 'Health check endpoint'}
        ]
    }), 200

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'error': True,
        'message': 'Resource not found'
    }), 404

@app.errorhandler(500)
def server_error(error):
    return jsonify({
        'error': True,
        'message': 'Internal server error'
    }), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8080))
    app.run(host='0.0.0.0', port=port) 