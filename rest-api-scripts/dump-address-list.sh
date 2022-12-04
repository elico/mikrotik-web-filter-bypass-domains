#!/usr/bin/env bash

HOST="${MT_HOST}"
USERNAME="${NT_USER}"
PASSWORD="${MT_PASSWORD}"

LIST_NAME="RW_BYPASS_DOMS"
QUERY_TEMPLATE='{".proplist": [".id","address","comment","creation-time","disabled","dynamic","list"], ".query": ["list=###LIST_NAME###", "dynamic=false"]}'

if [ ! -z "$1" ];then
	LIST_NAME="$1"
fi

QUERY=$( echo "${QUERY_TEMPLATE}" |sed -e "s@###LIST_NAME###@${LIST_NAME}@g")

curl -s -k -u "${USERNAME}:${PASSWORD}" "https://${HOST}/rest/ip/firewall/address-list/print" \
	--data "${QUERY}" -H "content-type: application/json" | jq -r '.[].address' 
