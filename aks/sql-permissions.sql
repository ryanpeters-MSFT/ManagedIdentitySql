-- assuming the Azure managed identity name is "ryan-workload", permissions must be granted to allow access to the database

CREATE USER [ryan-workload] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [ryan-workload];
ALTER ROLE db_datawriter ADD MEMBER [ryan-workload];
ALTER ROLE db_ddladmin ADD MEMBER [ryan-workload];