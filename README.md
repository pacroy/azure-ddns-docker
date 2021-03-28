# azure-ddns-docker
Docker image for Dynamic DNS with Azure DNS

## Create Service Principal

```sh
az ad sp create-for-rbac --name "{app-id-uri}" --role Contributor --scope "{resource-id}"
```

| Parameter | Description |
| --- | --- |
| app-id-uri | Application ID URI<br />Example: `sp://ddns-updater` |
| resource-id | DNS Zone Resource ID<br />Example: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-mygroup/providers/Microsoft.Network/dnszones/mydomain.com` |

## Execute

### Locally

```sh
export CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export CLIENT_SECRET="your-client-secret"
export TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export RESOURCE_GROUP="rg-mygroup"
export DNSZONE="mydomain.com"
export RECORD_NAME="@"
export COMMAND_IP="dig +short myotherdomain.com"
./entrypoint.sh
```

### Docker

```sh
docker build -t azure-ddns .
docker run -it --rm \          
    -e CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
    -e CLIENT_SECRET="your-client-secret" \
    -e TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
    -e RESOURCE_GROUP="rg-mygroup" \
    -e DNSZONE="mydomain.com" \
    -e RECORD_NAME="@" \
    -e COMMAND_IP="dig +short pacroy.thddns.net" \
    azure-ddns /work/entrypoint.sh
```
