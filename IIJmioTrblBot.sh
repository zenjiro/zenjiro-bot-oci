#!/bin/bash
set -u
red=🔴
green=🟢
orange=🟠
url="https://www.iijmio.jp"$(curl -s -S https://www.iijmio.jp/info/trouble/ | grep "障害発生報告" | head -1 | sed -E -e "s/.+<a href=\"([^\"]+)\">.+/\\1/")

raw_content=$(curl -s -S "$url")
timestamp=$(date +"%Y%m%d-%H%M%S")
log_file="iijmiotrblbot-${timestamp}.log"

latest_log=$(ls -t iijmiotrblbot-*.log 2>/dev/null | head -1)
if ! [ -f "$latest_log" ] || ! printf "%s" "$raw_content" | diff -q "$latest_log" - >/dev/null 2>&1; then
	printf "%s" "$raw_content" >"$log_file"
fi

content=$(printf "%s" "$raw_content" | sed -E -e "s/<[^>]+>//g" -e "s/-->//" -e "s/^\s+//" -e "/^$/d" -e "s/。ご迷惑を.+/。/" | awk "/^下記に示します/,/^影響サービス/;/^現象/,/^備考/" | grep -v -E -e "^＜ 記 ＞" -e "^影響サービス" -e "^備考|^以上" | tr "\n" "_" | sed "s/:_/：/g" | tr "_" "\n")

if [ -z "$content" ] || ! grep -q "下記に示します" <<<"$content"; then
	exit 0
fi

if echo "$content" | grep -q "対応作業中"; then
	echo "${red}下記に示します内容の障害が発生しています。"
	echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
elif echo "$content" | grep -q "調査中" && ! echo "$content" | grep -q "正常な状態"; then
	echo "${red}下記に示します内容の障害が発生しています（調査中）。"
	echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
elif echo "$content" | grep -q "復旧\|解消\|正常な状態"; then
	echo "${green}下記に示します内容の障害は復旧しました。"
	echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
else
	echo "${orange}下記に示します内容の障害が発生しました。"
	echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
fi
