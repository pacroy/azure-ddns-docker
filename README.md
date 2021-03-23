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
