#!/bin/bash
set -u
. export-keys.inc.sh
curl -s -S https://www.tokyu.co.jp/unten/unten2.json | jq -r .unten | sed "s/<br>/\n/g" | grep -E -v "現在\$" > ."${MY_SCREEN_NAME}"-now
. compare-and-tweet.inc.sh
