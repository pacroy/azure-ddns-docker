#!/usr/bin/env bash
set -o errexit
set -o pipefail

check_and_update_dns_record() {
    local RESOURCE_GROUP="$1"
    local DNSZONE="$2"
    local RECORD_NAME="$3"
    local UPDATE_IP="$4"

    local CURRENT_IP
    CURRENT_IP=$(az network dns record-set a show --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}" | jq -r '.arecords[0].ipv4Address')
    printf "\nChecking DNS record '%s'...\n" "${RECORD_NAME}"
    printf "  CURRENT_IP: %s\n" "${CURRENT_IP}"
    printf "  UPDATE_IP : %s\n" "${UPDATE_IP}"

    if [ "${CURRENT_IP}" != "${UPDATE_IP}" ]; then
        printf "  Updating DNS record..."
        az network dns record-set a update --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}" --remove arecords 0 > /dev/null
        az network dns record-set a update --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}" --add arecords ipv4Address="${UPDATE_IP}" > /dev/null
        printf "Done\n"
    else
        printf "  No update required\n"
    fi
}

printf "\nChecking variables...\n"
printf "CLIENT_ID     : %s\n" "${CLIENT_ID}"
printf "CLIENT_SECRET : %s\n" "***"
printf "TENANT_ID     : %s\n" "${TENANT_ID}"
printf "RESOURCE_GROUP: %s\n" "${RESOURCE_GROUP}"
printf "DNSZONE       : %s\n" "${DNSZONE}"
# shellcheck disable=SC2153
printf "RECORD_NAMES  : %s\n" "${RECORD_NAMES}"
printf "UPDATE_IP_CMD : %s\n" "${UPDATE_IP_CMD}"
[ -z "${CLIENT_ID}" ] && >&2 echo "CLIENT_ID is not set" && is_error="true"
[ -z "${CLIENT_SECRET}" ] && >&2 echo "CLIENT_SECRET is not set" && is_error="true"
[ -z "${TENANT_ID}" ] && >&2 echo "TENANT_ID is not set" && is_error="true"
[ -z "${RESOURCE_GROUP}" ] && >&2 echo "RESOURCE_GROUP is not set" && is_error="true"
[ -z "${DNSZONE}" ] && >&2 echo "DNSZONE is not set" && is_error="true"
[ -z "${RECORD_NAMES}" ] && >&2 echo "RECORD_NAMES is not set" && is_error="true"
[ -z "${UPDATE_IP_CMD}" ] && >&2 echo "UPDATE_IP_CMD is not set. Use default value 'curl -fsSL ipv4.icanhazip.com'"
[ -n "${is_error}" ] && exit 90

printf "\nLogging in...\n"
az login --service-principal -u "${CLIENT_ID}" -p "${CLIENT_SECRET}" --tenant "${TENANT_ID}" --output table

printf "\nGetting update IP...\n"
UPDATE_IP=$(${UPDATE_IP_CMD:-"curl -fsSL ipv4.icanhazip.com"})
[ -z "${UPDATE_IP}" ] && >&2 echo "Failed to get the IP" && exit 91
printf "  IP: %s\n" "${UPDATE_IP}"

for record in $RECORD_NAMES
do
    check_and_update_dns_record "${RESOURCE_GROUP}" "${DNSZONE}" "${record}" "${UPDATE_IP}"
done
