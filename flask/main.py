from flask import Flask

def create_app():
    app = Flask(__name__, instance_relative_config=True)

    @app.route('/')
    def index():
        return {"status": "Flask Service"}

    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
