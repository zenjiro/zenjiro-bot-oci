#!/bin/bash
# OCNモバイルの障害情報
set -u
red=🔴
green=🟢
result=$(curl -s -S https://support.ocn.ne.jp/$(curl -s -S https://support.ocn.ne.jp/mobile-one | grep 現在対応中の工事・故障情報 -A 9 | tail -1 | sed -E -e 's/.+<a href="([^"]+)".+/\1/') | grep '<h1 class="p-template__type1">' -A 20 | sed -E -e "s/(<br>)+/\n/g" -e "s/^\\s+//" -e "s/<[^>]+>//g" -e "/^$/d" | tail -n +3)
tail -2 <<< "$result" | grep 回復済み >/dev/null && echo -n "$green" || echo -n "$red"
head -n -6 <<< "$result"
