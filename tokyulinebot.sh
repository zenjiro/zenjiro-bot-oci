#!/bin/bash
set -u
curl -s -S https://www.tokyu.co.jp/unten/unten2.json | jq -r .unten | sed "s/<br>/\n/g" | grep -E -v "現在\$" > .tokyulinebot-now
[ -f .tokyulinebot-last ] && diff .tokyulinebot-now .tokyulinebot-last > /dev/null || (cat .tokyulinebot-now && ./tweet.sh post < .tokyulinebot-now)
mv .tokyulinebot-now .tokyulinebot-last
