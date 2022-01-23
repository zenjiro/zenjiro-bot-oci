#!/bin/bash
set -u -o pipefail
. export-keys.inc.sh
curl -s -S --location http://traininfo.jreast.co.jp/train_info/kanto.aspx | grep "<p class=\"mt10 sp_mt5 sp_mr25\">南武線" | sed -r -e "s|<[^>]+>||g" -e "s/&nbsp;//g" -e "s/[	 ^M]//g" -e "s/\r//g" > .nanbulinebot-now || echo 南武線は、現在平常運転しています。 > ."${MY_SCREEN_NAME}"-now
. compare-and-tweet.inc.sh
