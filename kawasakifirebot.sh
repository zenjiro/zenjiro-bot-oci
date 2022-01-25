#!/bin/bash
curl -s -S http://sc.city.kawasaki.jp/saigai/index.htm | nkf | grep '"point1.gif"' -A 4 | sed -E -e "s/^　? +　?|^--//" -e "s|<[^>]+>||g" -e "/^$/d" -e "s/ +$//" -e "s/(です|ます|せん)　/\\1。/g" -e "s/(さい|した|ます|しょう)$/\\1。/" -e "s/^[月０１２３４５６７８９]+日　//" -e "s/頃　/頃に/" -e "s/　//g" -e "y/０１２３４５６７８９/0123456789/"
