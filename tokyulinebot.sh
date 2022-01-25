#!/bin/bash
set -u
red=🔴
orange=🟠
green=🟢
curl -s -S https://www.tokyu.co.jp/unten/unten2.json | jq -r .unten | sed "s/<br>/\n/g" | grep -E -v "現在\$" | sed -E -e "1s/(.+(運休|折返し運転))/$red\\1/" -e "1s/(^[^$red].+平常通り運転)/$green\\1/" -e "1s/(^[^$red$green])/$orange\\1/"
