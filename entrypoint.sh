#!/usr/bin/env bash
set -o errexit
set -o pipefail

printf "\nLogging in...\n"
az login --service-principal -u "${CLIENT_ID}" -p "${CLIENT_SECRET}" --tenant "${TENANT_ID}" --output table

printf "\nChecking IP...\n"
dns_ip=$(az network dns record-set a show --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "{RECORD_NAME}")
cmd_ip=$(${COMMAND_IP})
printf "  DNS IP: %s\n" "${dns_ip}"
printf "  CMD IP: %s\n" "${cmd_ip}"

if [ "${dns_ip}" != "${cmd_ip" ]; then
    printf "\nUpdating IP...\n"
    az network dns record-set a update --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "{RECORD_NAME}" --remove arecords 0
    az network dns record-set a update --resource-group "${RESOURCE_GROUP}" --zone-name "${DNSZONE}" --name "{RECORD_NAME}" --add arecords ipv4Address="${cmd_ip}"
else
    printf "\nNo update required\n"
fi
