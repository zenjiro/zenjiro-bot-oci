#!/bin/bash
set -u
for _ in {1..10}
do
    ./run-all.sh &
    sleep 55
done
