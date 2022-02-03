#!/bin/bash
# 障害発生状況
set -u
red=🔴
url=$(curl -s -S https://www.uqwimax.jp/information/maintenance/ | grep "ＷｉＭＡＸ２＋通信障害" | head -1 | sed -E "s/.+<a href=\"(.+)\">.+/\\1/")
curl -s -S $url | grep "内容" -A 15 | sed -E -e "s|</em><br />|\n|" -e "s|<[^>]+>||g" -e "/^$/d" | sed -E -e "N;s/\n/：/" -e "s/^内容：/$red/" -e "s/ＷｉＭＡＸ２＋/WiMAX2+/"
