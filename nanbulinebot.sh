#!/bin/bash
set -u -o pipefail
red=🔴
orange=🟠
green=🟢
curl -s -S --location http://traininfo.jreast.co.jp/train_info/kanto.aspx | grep "<p class=\"mt10 sp_mt5 sp_mr25\">南武線" | sed -r -e "s|<[^>]+>||g" -e "s/&nbsp;//g" -e "s/[	 ^M]//g" -e "s/\r//g" -e "s/(.+(運転を見合わせています|運休となっています))/$red\\1/" -e "s/(^[^$red].+(遅れ|入場規制実施中))/$orange\\1/" -e "s/(^[^$red$orange])/$green\\1/" -e "y/０１２３４５６７８９/0123456789/" || echo "${green}南武線は、現在平常運転しています。"
