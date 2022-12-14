#!/bin/bash
set -u

function export_keys() {
    MY_SCREEN_NAME=$(basename "$1" .sh)
    export MY_SCREEN_NAME
    export MY_LANGUAGE=ja
    eval export CONSUMER_KEY="\$${MY_SCREEN_NAME,,}_API_KEY"
    eval export CONSUMER_SECRET="\$${MY_SCREEN_NAME,,}_API_SECRET_KEY"
    eval export ACCESS_TOKEN="\$${MY_SCREEN_NAME,,}_ACCESS_TOKEN"
    eval export ACCESS_TOKEN_SECRET="\$${MY_SCREEN_NAME,,}_ACCESS_TOKEN_SECRET"
}

for script in *{b,B}ot.sh
do
    export_keys "$script"
    bash "$script" | python3 truncate.py > ."${MY_SCREEN_NAME}"-now
    diff ."${MY_SCREEN_NAME}"-now ."${MY_SCREEN_NAME}"-last > /dev/null || (cat ."${MY_SCREEN_NAME}"-now && ./tweet.sh post < ."${MY_SCREEN_NAME}"-now)
    mv ."${MY_SCREEN_NAME}"-{now,last}
done
