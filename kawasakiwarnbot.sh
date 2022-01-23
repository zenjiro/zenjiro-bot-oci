#!/bin/bash
set -u
. export-keys.inc.sh
curl -s -S https://tenki.jp/bousai/warn/3/17/1413000/ | grep -E "<h2>.+市の警報・注意報" -A 10 | sed -E -e 's|</span><span class="is-alert">|／|g' -e "s|<[^>]+>||g" -e "s/^ +//" -e "/^$/d" -e "s/.+注意警戒事項：//" | tail -n +2 > ."${MY_SCREEN_NAME}"-now
. compare-and-tweet.inc.sh
