#!/bin/bash

resourceGroupName="CoolAppRG"
location="northeurope"
#vmName1="CoolAppVM"
vmName2="CoolAppVM2"
vmSize="Standard_B1s"
image="Ubuntu2204"
adminUsername="azureuser"
#vmport1="80"
vmport2="5000"

# Skapa en Virtuel network
az network vnet create \
    --resource-group $resourceGroupName \
    --name CoolAppVnet \
    --address-prefixes 10.1.0.0/16

# Skapa en subnet i nätverket
az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name CoolAppVnet \
    --name CoolAppSubnet \
    --address-prefixes 10.1.1.0/24

# Skapa resursgrupp
az group create --name $resourceGroupName --location $location

# # Skapa första VM
# az vm create \
#     --name $vmName1 \
#     --resource-group $resourceGroupName \
#     --image $image \
#     --admin-username $adminUsername \
#     --generate-ssh-keys \
#     --size $vmSize \
#     --location $location \
#     --custom-data @cloud-init_nginx.sh \

# Skapa andra VM
az vm create \
    --name $vmName2 \
    --resource-group $resourceGroupName \
    --image $image \
    --admin-username $adminUsername \
    --generate-ssh-keys \
    --size $vmSize \
    --location $location \
    --custom-data @cloud-init_dotnet.yaml \

#     #Efter att VM har skapats (i scriptet ovan eller efter annan script)
    INTERNAL_IP=$(az vm list-ip-addresses -n CoolAppVM2 -g CoolAppRG --query "[virtualIpAddresses].[0].ipAddress" -o tsv)

#az vm open-port --port $vmport1 --resource-group $resourceGroupName --name $vmName1

az vm open-port --port $vmport2 --resource-group $resourceGroupName --name $vmName2

