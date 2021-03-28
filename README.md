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
