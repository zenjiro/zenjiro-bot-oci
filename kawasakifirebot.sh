#!/bin/bash
set -u
red=🔴
orange=🟠
green=🟢
result=$(curl -s -S https://sc.city.kawasaki.jp/saigai/index.htm | nkf)
now=$(grep 現在 <<< "$result" | sed -E -e "s/.+ ([0-9]+時[0-9]+分現在).+/\\1/")
grep '"point1.gif"' -A 4 <<< "$result" | sed -E -e "s/^　? +　?|^--//" -e "s|<[^>]+>||g" -e "s/\r//g" -e "/^$/d" -e "s/ +$//" -e "s/(です|ます|せん)　/\\1。/g" -e "s/(さい|した|ます|しょう)$/\\1。/" -e "s/^[月０１２３４５６７８９]+日　//" -e "s/頃　/頃に/" -e "s/　//g" -e "y/０１２３４５６７８９/0123456789/" -e "s/(.+消防車が出場)/$red\\1/" -e "s/(.+(処理が完了|火災は鎮火))/$orange\\1/" -e "s/(.+(災害は発生しておりません|対応は終了|誤報でした))/$green\\1/" -e "s/只今、/$now、/"
