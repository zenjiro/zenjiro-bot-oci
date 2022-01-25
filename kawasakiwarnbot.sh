#!/bin/bash
set -u
red=🔴
orange=🟠
green=🟢
curl -s -S https://tenki.jp/bousai/warn/3/17/1413000/ | grep -E "<h2>.+市の警報・注意報" -A 10 | sed -E -e 's|</span><span class="is-alert">|／|g' -e "s|<[^>]+>||g" -e "s/^ +//" -e "/^$/d" -e "s/.+注意警戒事項：//" | tail -n +2 | sed -E -e "1s/(.+警報)/$red\\1/" -e "1s/(^[^$red].+注意報)/$orange\\1/" -e "1s/(^発表なし)/$green\\1/"
