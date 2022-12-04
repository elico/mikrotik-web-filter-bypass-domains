#!/usr/bin/env bash

HOST="${MT_HOST}"
USERNAME="${NT_USER}"
PASSWORD="${MT_PASSWORD}"

LIST_NAME="RW_BYPASS_DOMS"

if [ ! -z "$1" ];then
	LIST_NAME="$1"
fi

if [ ! -z "$2" ];then
        ADDRESS="$2"
fi

ADDRESS_ID=$(./get-address-list-item-id.sh "${LIST_NAME}" "${ADDRESS}")

curl -s -XDELETE -k  -u "${USERNAME}:${PASSWORD}" "https://${HOST}/rest/ip/firewall/address-list/${ADDRESS_ID}" 
