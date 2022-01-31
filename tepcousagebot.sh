#!/bin/bash
set -u
read usage capacity saving hour < <(echo $(curl -s -S http://tepco-usage-api.appspot.com/latest.json | jq -r ".usage, .capacity, .saving, .hour"))
percent=$(printf "%.0f\n" $(bc -l <<< "${usage}/${capacity}*100"))
usage=$(LC_ALL=en_US.UTF-8 printf "%'d" $usage)
capacity=$(LC_ALL=en_US.UTF-8 printf "%'d" $capacity)
echo "${hour}時台の消費電力：${usage}万kW/${capacity}万kW（${percent}%）"
