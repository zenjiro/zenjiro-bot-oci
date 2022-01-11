import requests

from flask import Flask

app = Flask(__name__)
app.logger.setLevel("INFO")


@app.route("/")
def hello():
    app.logger.info(requests.get("https://tenki.jp/bousai/warn/3/17/1413000/").text)
    return "こんにちは！"
