#!/usr/bin/env bash
set -o errexit
set -o pipefail

update_dns_record() {
# Parameters
    local RESOURCE_GROUP="$1"
    local DNSZONE="$2"
    local RECORD_NAME="$3"
    local IP="$4"
    az network dns record-set a update --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}" --remove arecords 0  > /dev/null
    az network dns record-set a update --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}" --add arecords ipv4Address="${IP}"
}

printf "\nChecking variables...\n"
echo "CLIENT_ID     : ${CLIENT_ID}\n"
echo "CLIENT_SECRET : ${CLIENT_SECRET}\n"
echo "TENANT_ID     : ${TENANT_ID}\n"
echo "RESOURCE_GROUP: ${RESOURCE_GROUP}\n"
echo "DNSZONE       : ${DNSZONE}\n"
echo "RECORD_NAME  : ${RECORD_NAME}\n"
echo "COMMAND_IP    : ${COMMAND_IP}\n"
[ -z "${CLIENT_ID}" ] && >&2 echo "CLIENT_ID is not set" && is_error="true"
[ -z "${CLIENT_SECRET}" ] && >&2 echo "CLIENT_SECRET is not set" && is_error="true"
[ -z "${TENANT_ID}" ] && >&2 echo "TENANT_ID is not set" && is_error="true"
[ -z "${RESOURCE_GROUP}" ] && >&2 echo "RESOURCE_GROUP is not set" && is_error="true"
[ -z "${DNSZONE}" ] && >&2 echo "DNSZONE is not set" && is_error="true"
[ -z "${RECORD_NAME}" ] && >&2 echo "RECORD_NAME is not set" && is_error="true"
[ -z "${COMMAND_IP}" ] && >&2 echo "COMMAND_IP is not set. Use default value 'curl -fsSL ipv4.icanhazip.com'"
[ -n "${is_error}" ] && exit 90

printf "\nLogging in...\n"
az login --service-principal -u "${CLIENT_ID}" -p "${CLIENT_SECRET}" --tenant "${TENANT_ID}" --output table

printf "\nChecking IP...\n"
dns_ip=$(az network dns record-set a show --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}" | jq -r '.arecords[0].ipv4Address')
cmd_ip=$(${COMMAND_IP:-"curl -fsSL ipv4.icanhazip.com"})
printf "  DNS IP: %s\n" "${dns_ip}"
printf "  CMD IP: %s\n" "${cmd_ip}"

if [ "${dns_ip}" != "${cmd_ip}" ]; then
    printf "\nUpdating IP...\n"
    update_dns_record "${RESOURCE_GROUP}" "${DNSZONE}" "${RECORD_NAME}" "${cmd_ip}"
else
    printf "\nNo update required\n"
    az network dns record-set a show --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "${RECORD_NAME}"
fi
