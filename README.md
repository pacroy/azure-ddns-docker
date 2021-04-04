# azure-ddns-docker

[![Lint Code Base](https://github.com/pacroy/azure-ddns-docker/actions/workflows/linter.yml/badge.svg)](https://github.com/pacroy/azure-ddns-docker/actions/workflows/linter.yml) [![Docker Build](https://github.com/pacroy/azure-ddns-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/pacroy/azure-ddns-docker/actions/workflows/docker-build.yml)

Docker image to update Azure DNS records to mimic Dynamic DNS service.

## Usage

### Service Principal

If you don't have a service principal yet, create a new one for querying and updating Azure DNS records

```sh
az ad sp create-for-rbac --name "{app-id-uri}" --role Contributor --scope "{resource-id}"
```

| Parameter | Description |
| --- | --- |
| app-id-uri | Application ID URI<br />Example: `sp://ddns-updater` |
| resource-id | DNS Zone Resource ID<br />Example: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-mygroup/providers/Microsoft.Network/dnszones/mydomain.com` |

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
    -e RECORD_NAMES="subdomain1 subdomain2" \
    -e UPDATE_IP_CMD="dig +short myotherdomain.com" \
    azure-ddns
```
