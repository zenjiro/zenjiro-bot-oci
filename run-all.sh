#!/bin/bash
set -u
for i in {1..10}
do
    (
	for script in *bot.sh
	do
	    echo $script $i
	    bash $script
	done
    ) &
    ((i < 10)) && sleep 60
done
