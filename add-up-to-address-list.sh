#!/usr/bin/env bash


ROUTEROS_ADDRESS="${MT_HOST}"
USERNAME="${NT_USER}"
PASSWORD="${MT_PASSWORD}"

ADDRESS="$1"
LIST_NAME="$2"
COMMENT="$3"

curl -s -k -u "${USERNAME}:${PASSWORD}" -X PUT "https://${ROUTEROS_ADDRESS}/rest/ip/firewall/address-list" \
	--data "{ \"address\": \"${ADDRESS}\" ,\"list\":\"${LIST_NAME}\", \"comment\": \"${COMMENT}\"}" \
        -H "content-type: application/json" ;echo
