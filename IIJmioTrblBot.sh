#!/bin/bash
set -u
red=🔴
green=🟢

# Get multiple recent trouble report URLs (check last 5 reports)
urls=$(curl -s -S https://www.iijmio.jp/info/trouble/ | grep "障害発生報告" | head -5 | sed -E -e "s/.+<a href=\"([^\"]+)\">.+/https:\/\/www.iijmio.jp\\1/")

all_content=""
has_ongoing_issues=false

# Check each recent trouble report
for url in $urls; do
    content=$(curl -s -S "$url" | sed -E -e "s/<[^>]+>//g" -e "s/-->//" -e "s/^\\s+//" -e "/^$/d" -e "s/。ご迷惑を.+/。/" | awk "/^下記に示します/,/^影響サービス/;/^現象/,/^備考/" | grep -v -E -e "^＜ 記 ＞" -e "^影響サービス" -e "^備考|^以上" | tr "\n" "_" | sed "s/:_/：/g" | tr "_" "\n")
    
    # Check if this report has ongoing issues
    if echo "$content" | grep -q "対応作業中\|調査中"; then
        has_ongoing_issues=true
        # Only include reports with ongoing issues in the output
        if [ -n "$all_content" ]; then
            all_content="$all_content

$content"
        else
            all_content="$content"
        fi
    fi
done

# If no ongoing issues found, show the most recent report (resolved)
if [ "$has_ongoing_issues" = false ]; then
    latest_url=$(echo "$urls" | head -1)
    all_content=$(curl -s -S "$latest_url" | sed -E -e "s/<[^>]+>//g" -e "s/-->//" -e "s/^\\s+//" -e "/^$/d" -e "s/。ご迷惑を.+/。/" | awk "/^下記に示します/,/^影響サービス/;/^現象/,/^備考/" | grep -v -E -e "^＜ 記 ＞" -e "^影響サービス" -e "^備考|^以上" | tr "\n" "_" | sed "s/:_/：/g" | tr "_" "\n")
fi

# Apply appropriate status indicator
if [ "$has_ongoing_issues" = true ]; then
    echo "$all_content" | sed -E -e "s/(下記に示します内容の障害が発生いたしました。)/$red\\1/"
else
    echo "$all_content" | sed -E -e "s/(下記に示します内容の障害が発生いたしました。)/$green\\1/"
fi
