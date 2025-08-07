# zenjiro-bot-oci
Oracle Cloudで動かすTwitterボット
# インストール
```
$ sudo apt install nkf jq python3 python3-pip
$ pip3 install -r requirements.txt
```
# 実行
$ export $(xargs < environment) && ./run-all.sh

# コードフォーマット
シェルスクリプトのフォーマットを統一するため、shfmtを使用します。
tweet.shは除外してフォーマットを実行してください。

```
$ shfmt -w $(find . -name "*.sh" -not -name "tweet.sh")
```
