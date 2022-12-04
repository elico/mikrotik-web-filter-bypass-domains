all:
	echo OK

gen-whatsapp:
	ruby gen-firewall-list.rb 0001-whatsapp.doms FILTER_BYPASS_DOMS > rsc/0001-whatsapp.rsc

gen-collection:
	cat ./*.doms | sort | uniq | grep -v -e '^[[:space:]]*$$' > collection/all.doms
	ruby gen-firewall-list.rb collection/all.doms RW_BYPASS_DOMS > rsc/collecton.rsc

gen-collection-update-script:
	cat mt-import-script-template |sed -e "s@##FILE##@/0010-collection.rsc@g" -e "s@##URL##@https://raw.githubusercontent.com/elico/mikrotik-web-filter-bypass-domains/master/rsc/collecton.rsc@g" -e "s@##LIST_NAME##@RW_BYPASS_DOMS@g"

git-add-collection:
	git add collection/all.doms rsc/collecton.rsc

git-commit:
	git commit -m "$(shell head -1 .counter && ./increment-counter.sh)"

git-add-changes:
	git add rsc/collecton.rsc collection/all.doms ./*.doms

git-push-changes:
	git push

push: git-add-changes git-commit git-push-changes

install:
	cp -v add-up-to-address-list.sh /usr/local/bin/add-up-to-address-list.sh
	cp -v update-mt-via-rest-api.sh /usr/local/bin/update-mt-via-rest-api.sh

update-rb4011:
	cd rest-api-scripts && ./update-mt-list.sh "RW_BYPASS_DOMS" "https://raw.githubusercontent.com/elico/mikrotik-web-filter-bypass-domains/master/collection/all.doms"
