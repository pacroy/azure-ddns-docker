# azure-ddns-docker

Docker image to update Azure DNS records to mimic Dynamic DNS service.

## Service Principal

Create a new service principal for querying and updating Azure DNS records

```sh
az ad sp create-for-rbac --name "{app-id-uri}" --role Contributor --scope "{resource-id}"
```

| Parameter | Description |
| --- | --- |
| app-id-uri | Application ID URI<br />Example: `sp://ddns-updater` |
| resource-id | DNS Zone Resource ID<br />Example: `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-mygroup/providers/Microsoft.Network/dnszones/mydomain.com` |

## Execute

Execute these commands to build and run the docker image

```sh
docker build --no-cache -t azure-ddns .
docker run -it --rm \          
    -e CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
    -e CLIENT_SECRET="your-client-secret" \
    -e TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
    -e RESOURCE_GROUP="rg-mygroup" \
    -e DNSZONE="mydomain.com" \
    -e RECORD_NAME="@" \
    -e COMMAND_IP="dig +short myotherdomain.com" \
    azure-ddns
```
