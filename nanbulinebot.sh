#!/bin/bash
set -u -o pipefail
export MY_SCREEN_NAME=$(basename $0 .sh)
export MY_LANGUAGE=ja
eval export CONSUMER_KEY="\$${MY_SCREEN_NAME}_API_KEY"
eval export CONSUMER_SECRET="\$${MY_SCREEN_NAME}_API_SECRET_KEY"
eval export ACCESS_TOKEN="\$${MY_SCREEN_NAME}_ACCESS_TOKEN"
eval export ACCESS_TOKEN_SECRET="\$${MY_SCREEN_NAME}_ACCESS_TOKEN_SECRET"
curl -s -S --location http://traininfo.jreast.co.jp/train_info/kanto.aspx | grep "<p class=\"mt10 sp_mt5 sp_mr25\">南武線" | sed -r -e "s|<[^>]+>||g" -e "s/&nbsp;//g" -e "s/[	 ^M]//g" -e "s/\r//g" > .nanbulinebot-now || echo 南武線は、現在平常運転しています。 > .nanbulinebot-now
[ -f .nanbulinebot-last ] && diff .nanbulinebot-now .nanbulinebot-last > /dev/null || (cat .nanbulinebot-now && ./tweet.sh post < .nanbulinebot-now)
mv .nanbulinebot-now .nanbulinebot-last
