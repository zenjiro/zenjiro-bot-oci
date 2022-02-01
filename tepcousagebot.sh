#!/bin/bash
set -u
# shellcheck disable=SC2046
read -r usage capacity saving hour < <(curl -s -S http://tepco-usage-api.appspot.com/latest.json | jq -r ".usage, .capacity, .saving, .hour" | tr "\n" " ")
# shellcheck disable=SC2086
percent=$(printf "%.0f\n" "$(bc -l <<< $usage/$capacity*100)")
usage=$(LC_ALL=en_US.UTF-8 printf "%'d" "$usage")
capacity=$(LC_ALL=en_US.UTF-8 printf "%'d" "$capacity")
saving=${saving/true/[計画停電中]}
echo "${saving/false/}${hour}時台の消費電力：${usage}万kW/${capacity}万kW（${percent}%）"
