#!/usr/bin/env bash

HOST="${MT_HOST}"
USERNAME="${NT_USER}"
PASSWORD="${MT_PASSWORD}"

LIST_NAME="RW_BYPASS_DOMS"

QUERY_TEMPLATE='{"address": "###ADDRESS##", "list": "###LIST_NAME###" }'


if [ ! -z "$1" ];then
	LIST_NAME="$1"
fi

if [ ! -z "$2" ];then
        ADDRESS="$2"
fi

QUERY=$( echo "${QUERY_TEMPLATE}" |sed -e "s@###LIST_NAME###@${LIST_NAME}@g" -e "s@###ADDRESS##@${ADDRESS}@g") 

curl -XPUT -k -u "${USERNAME}:${PASSWORD}" "https://${HOST}/rest/ip/firewall/address-list" \
	--data "${QUERY}" -H "content-type: application/json"
