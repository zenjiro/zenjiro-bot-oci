#!/bin/bash
# 復旧状況
set -u
green=🟢
url=https://www.uqwimax.jp/$(curl -s -S https://www.uqwimax.jp/information/maintenance/restore/area/kanto/ | sed "/^$/d" | grep -B 4 通信障害 | head -1 | sed -E "s/.+<a href=\"(.+)\" class=.+>/\\1/")
curl -s -S $url | grep "uqv2-parts-title--md typeBdr" -A 15 | sed -E -e "s/<[^>]+>//g" -e "s/ //g" -e "/^$/d" | nkf -Z | sed -E -e "N;s/\n/：/" -e "s/.+通信障害.+：/$green/"
