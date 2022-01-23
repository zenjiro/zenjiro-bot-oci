#!/bin/bash
set -u
psql "$DATABASE_URL" --command="SELECT message FROM status WHERE bot = '$MY_SCREEN_NAME';" --no-align --tuples-only > ."${MY_SCREEN_NAME}"-last
# shellcheck disable=SC2086
diff ."${MY_SCREEN_NAME}"-now ."${MY_SCREEN_NAME}"-last > /dev/null || (cat ."${MY_SCREEN_NAME}"-now && ./tweet.sh post < ."${MY_SCREEN_NAME}"-now && psql "$DATABASE_URL" --command="INSERT INTO status VALUES (DEFAULT, '${MY_SCREEN_NAME}', '$(cat .${MY_SCREEN_NAME}-now)') ON CONFLICT (bot) DO UPDATE SET timestamp = DEFAULT, message = '$(cat .${MY_SCREEN_NAME}-now)';")
