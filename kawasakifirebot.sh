#!/bin/bash
set -u
curl -s -S http://sc.city.kawasaki.jp/saigai/index.htm | nkf | grep '"point1.gif"' -A 4 | sed -E -e "s/^　? +　?|^--//" -e "s|<[^>]+>||g" -e "/^$/d" -e "s/ +$//" -e "s/です　/です。/" -e "s/ます　/ます。/" -e "s/せん　/せん。/" -e "s/さい$/さい。/"
