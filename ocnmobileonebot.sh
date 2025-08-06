#!/bin/bash
# ドコモの障害情報
set -u
red=🔴
green=🟢

# まず障害発生情報セクションをチェック
obstacle_info=$(curl -s -S https://www.docomo.ne.jp/info/network/ | grep -A 5 "障害発生情報")

# 「重大な障害発生情報などはありません」が含まれているかチェック
if echo "$obstacle_info" | grep -q "重大な障害発生情報などはありません"; then
	echo "${green}現在、ドコモの携帯電話サービス・各種サービスに重大な障害発生情報などはありません。"
else
	# 従来のロジックを実行（最新の障害情報を取得）
	url_path=$(curl -s -S https://www.docomo.ne.jp/info/network/ | grep -E -e 携帯電話サービス.+ご利用しづらい状況 | head -1 | sed -E 's/.+<a href="([^"]+)".+/\1/')
	if [ -n "$url_path" ]; then
		curl -s -S "https://www.docomo.ne.jp$url_path" | grep '<!--notice:body-->' -A 1 | tail -1 | sed -E -e "s/(<br>)+/\n/g" | sed -E -e "/^$/d" -e "/^平素は/d" -e "s/　//g" -e "s/^以下のとおり、.+、([^、]+正常にご利用.+)/$green\1/" -e "s/^以下のとおり、(.+)/$red\1/"
	else
		echo "${green}現在、携帯電話サービスに関する障害情報はありません。"
	fi
fi
