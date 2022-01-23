#!/bin/bash
set -u -o pipefail
. export-keys.inc.sh
curl -s -S --location http://traininfo.jreast.co.jp/train_info/kanto.aspx | grep "<p class=\"mt10 sp_mt5 sp_mr25\">南武線" | sed -r -e "s|<[^>]+>||g" -e "s/&nbsp;//g" -e "s/[	 ^M]//g" -e "s/\r//g" > .nanbulinebot-now || echo 南武線は、現在平常運転しています。 > .${MY_SCREEN_NAME}-now
psql "$DATABASE_URL" --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > .${MY_SCREEN_NAME}-last
diff .${MY_SCREEN_NAME}-now .${MY_SCREEN_NAME}-last > /dev/null || (cat .${MY_SCREEN_NAME}-now && ./tweet.sh post < .${MY_SCREEN_NAME}-now && psql "$DATABASE_URL" --command="INSERT INTO status VALUES (DEFAULT, '$MY_SCREEN_NAME', '$(cat .${MY_SCREEN_NAME}-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .${MY_SCREEN_NAME}-now)';")
