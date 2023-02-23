# Set ssome variabls
uniqueSuffix=weslbo
sqlUser=azureuser
read -p "Password for SQL Admin: " sqlPassword

# Create a directory called dp-203 and download the setupsqldwh.sql file from GitHub.
rm -r dp-203 -f
mkdir dp-203

wget https://raw.githubusercontent.com/weslbo/dp-203/main/automation/setupsqldwh.sql -O ./dp-203/setupsqldwh.sql
sqlcmd -S "synapse-$uniqueSuffix.sql.azuresynapse.net" -U $sqlUser -P $sqlPassword -d sqldwh -I -i ./dp-203/setupsqldwh.sql

# This code declares an array of strings called "files" which contains 10 different file names.
# It then iterates through each file name in the array and downloads two files with the same name from a given URL. 
# The files are then uploaded to the database using the BCP command.

declare -a files=("DimAccount" "DimCurrency" "DimCustomer" "DimDate" "DimDepartmentGroup" "DimEmployee" "DimGeography" "DimOrganization" "DimProduct" "DimProductCategory" "DimProductSubCategory" "DimPromotion" "DimReseller" "DimSalesTerritory" "FactInternetSales" "FactResellerSales")
for i in "${files[@]}"
do
    wget https://raw.githubusercontent.com/MicrosoftLearning/dp-203-azure-data-engineer/master/Allfiles/labs/08/data/$i.txt -O ./dp-203/$i.txt
    wget https://raw.githubusercontent.com/MicrosoftLearning/dp-203-azure-data-engineer/master/Allfiles/labs/08/data/$i.fmt -O ./dp-203/$i.fmt
    bcp dbo.$i in ./dp-203/$i.txt -S "synapse-$uniqueSuffix.sql.azuresynapse.net" -U $sqlUser -P $sqlPassword -d sqldwh -f ./dp-203/$i.fmt -q -k -E -b 5000
done

# This code creates a Kusto database in Azure Synapse. 
# The database is created without waiting for a response and is set to have a read-write access,
# located in West Europe and with a soft delete period of one day.
az synapse kusto database create --database-name sales-data --kusto-pool-name adx$uniqueSuffix --resource-group rg-dp-203 --workspace-name synapse-$uniqueSuffix --no-wait --read-write-database location="westeurope" soft-delete-period="P1D"

# This code creates a directory in the files container of the Azure Data Lake Storage Gen2 account.
az storage fs directory create -n RetailDB -f files --account-name datalake$uniqueSuffix --auth-mode login

# This code copies data from the the lab folder to the retaildb folder in the files container of the Azure Data Lake Storage Gen2 account.
azcopy login
azcopy copy "https://datalake$uniqueSuffix.dfs.core.windows.net/files/labs/04/data/customer.csv" "https://datalake$uniqueSuffix.dfs.core.windows.net/files/labs/04/RetailDB/Customer/customer.csv"