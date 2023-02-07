uniqueSuffix=dyfk4ryjqex56
sqlUser=azureuser
read -p "Password for SQL Admin: " sqlPassword

rm -r dp-203 -f
mkdir dp-203

wget https://raw.githubusercontent.com/weslbo/dp-203/main/automation/setupsqldwh.sql -O ./dp-203/setupsqldwh.sql
sqlcmd -S "synapse-$uniqueSuffix.sql.azuresynapse.net" -U $sqlUser -P $sqlPassword -d sqldwh -I -i ./dp-203/setupsqldwh.sql

declare -a files=("DimCurrency" "DimCustomer" "DimDate" "DimGeography" "DimProduct" "DimProductCategory" "DimProductSubcategory" "DimPromotion" "DimSalesTerritory" "FactInternetSales")
for i in "${files[@]}"
do
    wget https://raw.githubusercontent.com/MicrosoftLearning/dp-203-azure-data-engineer/master/Allfiles/labs/01/data/$i.txt -O ./dp-203/$i.txt
    wget https://raw.githubusercontent.com/MicrosoftLearning/dp-203-azure-data-engineer/master/Allfiles/labs/01/data/$i.fmt -O ./dp-203/$i.fmt
    bcp dbo.$i in ./dp-203/$i.txt -S "synapse-$uniqueSuffix.sql.azuresynapse.net" -U $sqlUser -P $sqlPassword -d sqldwh -f ./dp-203/$i.fmt -q -k -E -b 5000
done

az synapse kusto database create --database-name sales-data --kusto-pool-name adx$uniqueSuffix --resource-group rg-dp-203 --workspace-name synapse-$uniqueSuffix --no-wait --read-write-database location="westeurope" soft-delete-period="P1D"