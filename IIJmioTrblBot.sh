#!/bin/bash
set -u
red=🔴
green=🟢
url="https://www.iijmio.jp"$(curl -s -S https://www.iijmio.jp/info/trouble/ | grep "障害発生報告" | head -1 | sed -E -e "s/.+<a href=\"([^\"]+)\">.+/\\1/")

# Get raw content and save to timestamped log file
raw_content=$(curl -s -S "$url")
timestamp=$(date +"%Y%m%d-%H%M%S")
log_file="iijmiotrblbot-${timestamp}.log"

# Check if content is different from the most recent log file
latest_log=$(ls -t iijmiotrblbot-*.log 2>/dev/null | head -1)
if ! [ -f "$latest_log" ] || ! printf "%s" "$raw_content" | diff -q "$latest_log" - >/dev/null 2>&1; then
	# Content is different or no previous log exists, save new log file
	printf "%s" "$raw_content" >"$log_file"
fi

content=$(printf "%s" "$raw_content" | sed -E -e "s/<[^>]+>//g" -e "s/-->//" -e "s/^\s+//" -e "/^$/d" -e "s/。ご迷惑を.+/。/" | awk "/^下記に示します/,/^影響サービス/;/^現象/,/^備考/" | grep -v -E -e "^＜ 記 ＞" -e "^影響サービス" -e "^備考|^以上" | tr "\n" "_" | sed "s/:_/：/g" | tr "_" "\n")

# Check if content is empty or invalid
if [ -z "$content" ] || ! grep -q "下記に示します" <<<"$content"; then
	# Don't post anything if content is empty or doesn't contain expected text
	exit 0
fi

# Check if the issue is resolved or ongoing
if echo "$content" | grep -q "対応作業中\|調査中"; then
	echo "${red}下記に示します内容の障害が発生いたしました。"
	echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
else
	echo "${green}下記に示します内容の障害が発生いたしました。"
	echo "$content" | grep -v "^下記に示します内容の障害が発生いたしました。"
fi
