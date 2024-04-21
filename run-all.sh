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
    echo "$script"
    export_keys "$script"
    bash "$script" | python3 truncate.py > ."${MY_SCREEN_NAME}"-now
    diff ."${MY_SCREEN_NAME}"-now ."${MY_SCREEN_NAME}"-last > /dev/null || (cat ."${MY_SCREEN_NAME}"-now && ./tweet.sh post < ."${MY_SCREEN_NAME}"-now)
    mv ."${MY_SCREEN_NAME}"-{now,last}
done
for script in yokohamafirebot.sh
do
    echo "$script"
    screen_name=$(basename "$script" .sh)
    bash "$script" | python3 truncate.py > ."${screen_name}"-now
    diff ."${screen_name}"-now ."${screen_name}"-last > /dev/null || (cat ."${screen_name}"-now && python3 post.py "${screen_name}" < ."${screen_name}"-now)
    mv ."${screen_name}"-{now,last}
done
