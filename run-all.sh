#!/bin/bash
set -u

function export_keys() {
    MY_SCREEN_NAME=$(basename "$1" .sh)
    export MY_SCREEN_NAME
    export MY_LANGUAGE=ja
    eval export CONSUMER_KEY="\$${MY_SCREEN_NAME}_API_KEY"
    eval export CONSUMER_SECRET="\$${MY_SCREEN_NAME}_API_SECRET_KEY"
    eval export ACCESS_TOKEN="\$${MY_SCREEN_NAME}_ACCESS_TOKEN"
    eval export ACCESS_TOKEN_SECRET="\$${MY_SCREEN_NAME}_ACCESS_TOKEN_SECRET"
}

for script in *bot.sh
do
    export_keys "$script"
    bash "$script" | python3 truncate.py > ."${MY_SCREEN_NAME}"-now
    psql "$DATABASE_URL" --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > ."${MY_SCREEN_NAME}"-last
    # shellcheck disable=SC2086
    diff ."${MY_SCREEN_NAME}"-now ."${MY_SCREEN_NAME}"-last > /dev/null || (cat ."${MY_SCREEN_NAME}"-now && psql "$DATABASE_URL" --command="INSERT INTO status VALUES (DEFAULT, '${MY_SCREEN_NAME}', '$(cat .${MY_SCREEN_NAME}-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .${MY_SCREEN_NAME}-now)';" && ./tweet.sh post < ."${MY_SCREEN_NAME}"-now)
done
