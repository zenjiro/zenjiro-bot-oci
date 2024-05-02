#!/bin/bash
# ドコモの障害情報
set -u
red=🔴
green=🟢
curl -s -S https://www.docomo.ne.jp/$(curl -s -S https://www.docomo.ne.jp/info/network/ | grep -E -e 携帯電話サービス.+ご利用しづらい状況 | head -1 | sed -E 's/.+<a href="([^"]+)".+/\1/') | grep '<!--notice:body-->' -A 1 | tail -1 | sed -E -e "s/(<br>)+/\n/g" | sed -E -e "/^$/d" -e "/^平素は/d" -e "s/　//g" -e "s/^以下のとおり、.+、([^、]+正常にご利用.+)/$green\1/" -e "s/^以下のとおり、(.+)/$red\1/"
