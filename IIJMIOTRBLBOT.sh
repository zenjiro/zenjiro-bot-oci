#!/bin/bash
# ドコモの通信状況
curl -s -S https://www.nttdocomo.co.jp/info/status/ | grep 神奈川 | sed -E -e "s/^\s+//" -e "s/ (class|headers)=\"[^\"]+\"//g"
