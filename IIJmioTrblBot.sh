#!/bin/bash
set -u
red=🔴
green=🟢
url="https://www.iijmio.jp"$(curl -s -S https://www.iijmio.jp/info/trouble/ | grep "障害発生報告" | head -1 | sed -E -e "s/.+<a href=\"([^\"]+)\">.+/\\1/")
content=$(curl -s -S "$url" | sed -E -e "s/<[^>]+>//g" -e "s/-->//" -e "s/^\\s+//" -e "/^$/d" -e "s/。ご迷惑を.+/。/" | awk "/^下記に示します/,/^影響サービス/;/^現象/,/^備考/" | grep -v -E -e "^＜ 記 ＞" -e "^影響サービス" -e "^備考|^以上" | tr "\n" "_" | sed "s/:_/：/g" | tr "_" "\n")

# Check if the issue is resolved or ongoing
if echo "$content" | grep -q "対応作業により障害は解消\|正常な状態にて運用中\|復旧いたしました"; then
    echo "$content" | sed -E -e "s/(下記に示します内容の障害が発生いたしました。)/$green\\1/"
elif echo "$content" | grep -q "対応作業中\|調査中"; then
    echo "${red}下記に示します内容の障害が発生いたしました。"
    echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
else
    echo "$content" | sed -E -e "s/(下記に示します内容の障害が発生いたしました。)/$green\\1/"
fi
