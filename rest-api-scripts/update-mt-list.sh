#!/usr/bin/env bash

CLEANUP_AFTER="1"

LIST_NAME="$1"
URL="$2"

CURRENT_LIST_CONTENT_FILENAME=$(mktemp)
REMOTE_LIST_CONTENT_FILENAME=$(mktemp)

TMP_TRANSACTION_FILE=$( mktemp )

/usr/bin/curl -k -s "${URL}" |sort > "${REMOTE_LIST_CONTENT_FILENAME}" 

./dump-address-list.sh "${LIST_NAME}"  | sort > "${CURRENT_LIST_CONTENT_FILENAME}"



DIFF=$( diff -u "${CURRENT_LIST_CONTENT_FILENAME}" "${REMOTE_LIST_CONTENT_FILENAME}" |sed -e "1,3d;")
echo "${DIFF}"

##
DELETE_OBJECTS=$( echo "${DIFF}" |egrep "^\-" |sed -e "s@^\-@@")

for object in ${DELETE_OBJECTS}; do
        echo "/ip/firewall/address-list/remove list=${LIST_NAME} address=${object}" >> ${TMP_TRANSACTION_FILE}
	./remove-address-to-address-list.sh "${LIST_NAME}" "${object}"
	echo
done

APPEND_OBJECTS=$( echo "${DIFF}" |egrep "^\+" |sed -e "s@^\+@@")

for object in ${APPEND_OBJECTS}; do
        echo "/ip/firewall/address-list/add list=${LIST_NAME} address=${object}" >> ${TMP_TRANSACTION_FILE}
	./add-address-to-address-list.sh "${LIST_NAME}" "${object}"
	echo
done
##

cat "${TMP_TRANSACTION_FILE}"

echo "Finished Transaction"
echo "Cleaning up files ..."

if [ "${CLEANUP_AFTER}" -eq "1" ];then
	rm -v "${TMP_TRANSACTION_FILE}"
	rm -v "${CURRENT_LIST_CONTENT_FILENAME}"
	rm -v "${REMOTE_LIST_CONTENT_FILENAME}"

else
        echo "Don't forget to cleanup the files:"
	echo "${TMP_TRANSACTION_FILE}"
        echo "${CURRENT_LIST_CONTENT_FILENAME}"
        echo "${REMOTE_LIST_CONTENT_FILENAME}"
fi

rm -fv "${LOCK_FILE}"

logger "Finished running a address list update for: LIST => \"${LIST_NAME}\" , from URL => \"${URL}\""

set +x

