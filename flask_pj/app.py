#dairen 20181103
from flask import Flask
app = Flask(__name__)

@app.route('/hello')
@app.route('/')
def index():
    return '<h1>Hello World!</h1>'


@app.route('/arg',defaults={'name':'daidaotian'})
@app.route('/arg/<name>')
def hi(name):
    return "hello! %s !"%name
if __name__ == '__main__':
    app.run()
