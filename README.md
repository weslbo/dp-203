# DP-203 Setup for trainers (MCT)

Welcome to this repository, which aims to help MCT trainers to deploy a demo environment. It builds further on the work already done at the official [DP-203: Azure Data Engineer](https://github.com/MicrosoftLearning/dp-203-azure-data-engineer) git repository, which contains instructions and assets for hands-on excercises.

The [dp-203.bicep](./automation/dp-203.bicep) template can be used to deploy all the required resources:

- Data Lake with containers
- Synapse workspace
- Dedicated pool (will be paused every 2 hours)
- Spark pool (auto pause after 15 minutes of inactivity)
- Data explorer pool (will be paused every 2 hours)
- SQL Server with AdventureWorksLT database
- Eventhub + namespace
- Purview account
- Logic app to pause dedicated pool and data explorer pool every 2 hours
- Cosmos DB Account (no database yet)
- Databricks (without cluster)

To deploy this environment:

```bash
read -s "password?Password for SQL Admin:?"
az group create --name rg-dp-203 --location westeurope
az deployment group create --name dp-203  --resource-group rg-dp-203 --template-file dp-203.bicep --parameters sqlUser=azureuser sqlPassword=$password
```