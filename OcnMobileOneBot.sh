#!/bin/bash
# OCNモバイルの障害情報
set -u
red=🔴
green=🟢
white=⚪
url="https://support.ocn.ne.jp/$(curl -s -S https://support.ocn.ne.jp/mobile-one/ | grep 現在対応中の工事・故障情報 -A 9 | tail -1 | sed -E -e 's/.+<a href=\"([^\"]+)\".+/\1/')/"
raw_content=$(curl -s -S --location "$url")
if [ -z "$raw_content" ]; then
	echo "Error: Failed to fetch content from $url" >&2
	exit 1
fi
timestamp=$(date +"%Y%m%d-%H%M%S")
log_file="ocnmobileonebot-${timestamp}.log"
latest_log=$(ls -t ocnmobileonebot-*.log 2>/dev/null | head -1)
if ! [ -f "$latest_log" ] || ! printf "%s" "$raw_content" | diff -q "$latest_log" - >/dev/null 2>&1; then
	printf "%s" "$raw_content" >"$log_file"
fi
result=$(printf "%s" "$raw_content" | grep '<h1 class="p-template__type1">' -A 20 | sed -E -e "s/(<br>)+/\n/g" -e "s/^\\s+//" -e "s/<[^>]+>//g" -e "/^$/d" | tail -n +3)
display=$(sed -E '/^【更新】$/,/^-+$/d' <<<"$result")
if tail -2 <<<"$result" | grep 回復済み >/dev/null; then
	echo -n "$green"
elif echo "$result" | grep -E "(発生日時.*変更|変更.*発生日時|■変更前|■変更後|日時.*変更.*いたしました)" >/dev/null; then
	echo -n "$white"
else
	echo -n "$red"
fi
head -n -6 <<<"$display"
