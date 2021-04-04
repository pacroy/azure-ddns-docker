# azure-ddns-docker

[![Lint Code Base](https://github.com/pacroy/azure-ddns-docker/actions/workflows/linter.yml/badge.svg)](https://github.com/pacroy/azure-ddns-docker/actions/workflows/linter.yml) [![Docker Build](https://github.com/pacroy/azure-ddns-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/pacroy/azure-ddns-docker/actions/workflows/docker-build.yml)

Docker image to update Azure DNS records to mimic Dynamic DNS service.

## Usage

### Service Principal

If you don't have a service principal yet, you may create a new one as we will use it to query and update Azure DNS records.

```sh
az ad sp create-for-rbac --name "<APP_ID_URI>" --role Contributor --scope "<RESOURCE_ID>"
```

| Parameter | Description |
| --- | --- |
| APP_ID_URI | Application ID URI<br />Example: `sp://ddns-updater` |
| RESOURCE_ID | DNS Zone Resource ID<br />Example: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-mygroup/providers/Microsoft.Network/dnszones/mydomain.com` |

### Get Image

#### Pull Image

```sh
docker pull ghcr.io/pacroy/azure-ddns
docker tag ghcr.io/pacroy/azure-ddns azure-ddns
```

#### Build Locally

```sh
docker build --no-cache -t azure-ddns .
```

### Execute

```sh
docker run --interactive --rm \          
    -e CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
    -e CLIENT_SECRET="your-client-secret" \
    -e TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
    -e RESOURCE_GROUP="rg-mygroup" \
    -e DNSZONE="mydomain.com" \
    -e RECORD_NAMES="record1 record2" \
    -e UPDATE_IP_CMD="dig +short myotherdomain.com" \
    azure-ddns
```

| Parameter | Description |
| --- | --- |
| CLIENT_ID | AzureAD application ID or ID URI of the [service principal](#Service-Principal) |
| CLIENT_SECRET | Secret of service principal |
| TENANT_ID | AzureAD tenant ID |
| RESOURCE_GROUP | Resource group of the DNS zone |
| DNSZONE | DNS zone name |
| RECORD_NAMES | DNS record names, separated by space |
| UPDATE_IP_CMD | Command to get the up-to-date IP<br />Leave blank use default `curl -fsSL ipv4.icanhazip.com` to use the external IP of the host<br />Or set `dig +short myotherdomain.com` to clone IP from the other domain.  |
