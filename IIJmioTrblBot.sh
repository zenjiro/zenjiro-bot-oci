#!/bin/bash
set -u
url="https://www.iijmio.jp"$(curl -s -S https://www.iijmio.jp/info/trouble/ | grep "障害発生報告" | head -1 | sed -E -e "s/.+<a href=\"([^\"]+)\">.+/\\1/")
curl -s -S "$url" | sed -E -e "s/<[^>]+>//g" -e "s/-->//" -e "s/^\\s+//" -e "/^$/d" -e "s/。ご迷惑を.+/。/" | awk "/^下記に示します/,/^影響サービス/;/^現象/,/^備考/" | grep -v -E -e "^＜ 記 ＞" -e "^影響サービス" -e "^備考|^以上" | tr "\n" "_" | sed "s/:_/：/g" | tr "_" "\n"
