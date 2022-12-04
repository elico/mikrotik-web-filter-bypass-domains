#!/usr/bin/env bash

curl -s http://gogs.ngtech.home/NgTech-Home/mikrotik-web-filter-bypass-domains/raw/master/collection/all.doms | \
	xargs -P 10 -l1 -n1 -I{} /usr/local/bin/add-up-to-address-list.sh {} "RW_BYPASS_DOMS" "NGTECH1LTD"
