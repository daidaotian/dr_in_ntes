#dairen 20181103
from flask import Flask
app = Flask(__name__)

@app.route('/hello')
@app.route('/')
@app.route('/hi')
def index():

    return '<h1>Hello World!</h1>'


@app.route('/arg',defaults={'name':'daidaotian'})
@app.route('/arg/<name>')
def hi(name):
    teststr = url_for('hi', 'dddddd')

    return "hello! %s !,%s"%(name,teststr)

@app.cli.command('hello')
def hi_main():
    click.echo('hello,young man!')


if __name__ == '__main__':
    app.run()
