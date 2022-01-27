#!/bin/bash
set -u
red1=○
red2=🔴
white=⚪
curl -s -S https://cgi.city.yokohama.lg.jp/shobo/disaster/ | awk /【災害情報案内】/,/横浜市消防局からのお願いです。/ | sed -E -e 1d -e \$d -e "s/。　+/。/" -e "s/<[^>]+>//g" -e "/^$/d" -e "s/(.+消防隊)/$red1\\1/" -e "s/(^[^$red1]+救助隊)/$white\\1/" | sed -z "s/\n/！/g" | cut -b 1-420 | sed -E -e "s/！/\n/g" -e "y/${red1}０１２３４５６７８９　/${red2}0123456789 /"
