#!/bin/bash
set -u
curl -s -S https://tenki.jp/bousai/warn/3/17/1413000/ | grep -E "<h2>.+市の警報・注意報" -A 10 | sed -E -e 's|</span><span class="is-alert">|／|g' -e "s|<[^>]+>||g" -e "s/^ +//" -e "/^$/d" -e "s/.+注意警戒事項：//" | tail -n +2 > .kawasakiwarnbot-now
[ -f .kawasakiwarnbot-last ] && diff .kawasakiwarnbot-now .kawasakiwarnbot-last > /dev/null || (cat .kawasakiwarnbot-now && ./tweet.sh post < .kawasakiwarnbot-now)
mv .kawasakiwarnbot-now .kawasakiwarnbot-last
