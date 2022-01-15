#!/bin/bash
set -u -o pipefail
export MY_SCREEN_NAME=$(basename $0 .sh)
export MY_LANGUAGE=ja
eval export CONSUMER_KEY="\$${MY_SCREEN_NAME}_API_KEY"
eval export CONSUMER_SECRET="\$${MY_SCREEN_NAME}_API_SECRET_KEY"
eval export ACCESS_TOKEN="\$${MY_SCREEN_NAME}_ACCESS_TOKEN"
eval export ACCESS_TOKEN_SECRET="\$${MY_SCREEN_NAME}_ACCESS_TOKEN_SECRET"
