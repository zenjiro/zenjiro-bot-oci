#!/bin/bash
set -u -o pipefail
. export-keys.inc.sh
for i in {1..10}
do
    echo $0 $i
    curl -s -S --location http://traininfo.jreast.co.jp/train_info/kanto.aspx | grep "<p class=\"mt10 sp_mt5 sp_mr25\">南武線" | sed -r -e "s|<[^>]+>||g" -e "s/&nbsp;//g" -e "s/[	 ^M]//g" -e "s/\r//g" > .nanbulinebot-now || echo 南武線は、現在平常運転しています。 > .nanbulinebot-now
    psql $DATABASE_URL --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > .nanbulinebot-last
    diff .nanbulinebot-now .nanbulinebot-last > /dev/null || (cat .nanbulinebot-now && ./tweet.sh post < .nanbulinebot-now && psql $DATABASE_URL --command="INSERT INTO status VALUES (DEFAULT, '$MY_SCREEN_NAME', '$(cat .nanbulinebot-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .nanbulinebot-now)';")
    sleep 60
done
