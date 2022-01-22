#!/bin/bash
set -u
. export-keys.inc.sh
curl -s -S https://www.tokyu.co.jp/unten/unten2.json | jq -r .unten | sed "s/<br>/\n/g" | grep -E -v "現在\$" > .tokyulinebot-now
psql "$DATABASE_URL" --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > .tokyulinebot-last
diff .tokyulinebot-now .tokyulinebot-last > /dev/null || (cat .tokyulinebot-now && ./tweet.sh post < .tokyulinebot-now && psql "$DATABASE_URL" --command="INSERT INTO status VALUES (DEFAULT, '$MY_SCREEN_NAME', '$(cat .tokyulinebot-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .tokyulinebot-now)';")
