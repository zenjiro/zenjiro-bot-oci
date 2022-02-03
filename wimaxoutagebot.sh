#!/bin/bash
# 復旧状況
set -u
green=🟢
url=$(curl -s -S https://www.uqwimax.jp/information/maintenance/ | sed "/^$/d" | grep -A 40 "復旧状況" | grep "ＷｉＭＡＸ２＋通信障害" | head -1 | sed -E "s/.+<a href=\"(.+)\">.+/\\1/")
curl -s -S $url | grep "内容" -A 15 | sed -E -e "s|</em><br />|\n|" -e "s|<[^>]+>||g" -e "/^$/d" | sed -E -e "N;s/\n/：/" -e "s/^内容：/$green/" -e "s/ＷｉＭＡＸ２＋/WiMAX2+/" -e "/対象サービス/d" -e "s/^対象エリア：//"
echo $url
