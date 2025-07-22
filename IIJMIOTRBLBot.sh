#!/bin/bash
set -u
red=🔴
green=🟢
orange=🟠

# ドコモの通信状況（神奈川県）
row=$(curl -s -S https://www.docomo.ne.jp/info/status/ | grep -A1 神奈川)

if echo "$row" | grep -q "img_good.png\|正常"; then
    echo "${green}ドコモ神奈川県：正常"
elif echo "$row" | grep -q "img_bad.png\|障害"; then
    echo "${red}ドコモ神奈川県：障害発生中"
elif echo "$row" | grep -q "img_caution.png\|注意"; then
    echo "${orange}ドコモ神奈川県：要注意"
else
    echo "${orange}ドコモ神奈川県：状況確認中"
fi
