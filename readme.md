# Connect to Azure SQL Server using AKS Workload Identity

### Setup:

1. Create a Azure SQL server and database. Update the connection string in `appsettings.json` (be sure to use the *passwordless authentication* option)
2. Build the app using Docker by invoking `aks/deploy.sh` (Linux) or `aks\deploy.ps1` (Windows). Be sure to update the `Dockerfile` with your desired tag, using the registry of your choice.
3. TBD
4. Invoke `sql-permissions.sql` to set read, write, and DDL admin rights ([More information](https://learn.microsoft.com/en-us/azure/azure-sql/database/azure-sql-dotnet-quickstart?view=azuresql&tabs=visual-studio%2Cpasswordless%2Cazure-portal%2Cportal#create-the-database-user-and-assign-roles))

### Notes:

- Ensure the pod template has the label `azure.workload.identity/use` set to `"true"`