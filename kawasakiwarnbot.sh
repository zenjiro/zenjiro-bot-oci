#!/bin/bash
set -u
. export-keys.inc.sh
curl -s -S https://tenki.jp/bousai/warn/3/17/1413000/ | grep -E "<h2>.+市の警報・注意報" -A 10 | sed -E -e 's|</span><span class="is-alert">|／|g' -e "s|<[^>]+>||g" -e "s/^ +//" -e "/^$/d" -e "s/.+注意警戒事項：//" | tail -n +2 > .${MY_SCREEN_NAME}-now
psql "$DATABASE_URL" --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > .${MY_SCREEN_NAME}-last
diff .${MY_SCREEN_NAME}-now .${MY_SCREEN_NAME}-last > /dev/null || (cat .${MY_SCREEN_NAME}-now && ./tweet.sh post < .${MY_SCREEN_NAME}-now && psql "$DATABASE_URL" --command="INSERT INTO status VALUES (DEFAULT, '$MY_SCREEN_NAME', '$(cat .${MY_SCREEN_NAME}-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .${MY_SCREEN_NAME}-now)';")
