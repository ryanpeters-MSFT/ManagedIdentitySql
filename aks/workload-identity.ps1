$group = "rg-aks-workload"
$namespace = "managedidentity" # kubernetes namespace of the service account
$cluster_name = "workloadcluster"
$service_account_name = "cluster-workload-user" # kubernetes service account name
$federated_name = "federated-workload-user" # id used for federated credential
$azure_managed_identity = "ryan-workload" # workload managed identity in Azure

az group create -n $group -l eastus2

# create cluster with workload identity and secrets provider add-on
az aks create -n $cluster_name --node-count 1 --node-osdisk-type ephemeral --node-vm-size Standard_DS3_v2 -g $group --enable-oidc-issuer --enable-workload-identity --enable-addons azure-keyvault-secrets-provider

# OR, enable the add-on
#az aks enable-addons --addons azure-keyvault-secrets-provider -n $cluster_name -g $group

# create the azure managed identity
az identity create -n $azure_managed_identity -g $group

# get OIDC issuer
$oidc_issuer = az aks show -n $cluster_name -g $group --query oidcIssuerProfile.issuerUrl -o tsv
#az aks show -n $cluster_name -g $group --query oidcIssuerProfile.issuerUrl -o tsv

$user_assigned_client_id = az identity show -n $azure_managed_identity -g $group --query clientId -o tsv

# create the federated 
az identity federated-credential create --name $federated_name --identity-name $azure_managed_identity -g $group --issuer $oidc_issuer --subject system:serviceaccount:$($namespace):$($service_account_name) --audience api://AzureADTokenExchange

# FOR KEYVAULT
#az keyvault set-policy -n workloadvault --secret-permissions get --spn $user_assigned_client_id

# dumps
$oidc_issuer
$user_assigned_client_id