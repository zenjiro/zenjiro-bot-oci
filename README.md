# zenjiro-bot-oci
Oracle Cloudで動かすTwitterボット
# インストール
```
$ sudo apt install nkf jq python3 python3-pip
$ pip3 install -r requirements.txt
```
# 実行
$ export $(xargs < environment) && ./run-all.sh

## cron設定
ボットを定期的に実行するため、cronで以下のコマンドを設定してください：
```
cd /path/to/directory && export $(xargs < environment) && ./run-all.sh
```

# コードフォーマット
シェルスクリプトのフォーマットを統一するため、shfmtを使用します。
tweet.shは除外してフォーマットを実行してください。

```
$ find . -name "*.sh" -not -name "tweet.sh" -exec shfmt -w {} +
```
