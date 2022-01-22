#!/bin/bash
set -u
. export-keys.inc.sh
curl -s -S https://tenki.jp/bousai/warn/3/17/1413000/ | grep -E "<h2>.+市の警報・注意報" -A 10 | sed -E -e 's|</span><span class="is-alert">|／|g' -e "s|<[^>]+>||g" -e "s/^ +//" -e "/^$/d" -e "s/.+注意警戒事項：//" | tail -n +2 > .kawasakiwarnbot-now
psql "$DATABASE_URL" --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > .kawasakiwarnbot-last
diff .kawasakiwarnbot-now .kawasakiwarnbot-last > /dev/null || (cat .kawasakiwarnbot-now && ./tweet.sh post < .kawasakiwarnbot-now && psql "$DATABASE_URL" --command="INSERT INTO status VALUES (DEFAULT, '$MY_SCREEN_NAME', '$(cat .kawasakiwarnbot-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .kawasakiwarnbot-now)';")
