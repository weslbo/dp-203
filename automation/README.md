# Deployment

This repository builds further on the work already done at the official [DP-203: Azure Data Engineer](https://github.com/MicrosoftLearning/dp-203-azure-data-engineer) git repository, which contains instructions and assets for hands-on excercises.

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

1. Open the [Azure Portal](https://portal.azure.com)
1. Open the Azure Cloud Shell using **BASH**
1. Execute the following command

    ```azurecli
    rm -r dp-203 -f
    git clone https://github.com/weslbo/dp-203.git
    cd dp-203
    userobjectid=$(az ad signed-in-user show --query id --output tsv)
    powerBIAdminEmailAddress=$(az ad signed-in-user show --query mail --output tsv)
    uniqueSuffix=weslbo
    read -p "Password for SQL Admin: " password
    ```

1. Execute the following commands to deploy the demo environment (this will take ~25 minutes). Any warning can be safely ignored. The data explorer pool takes the most time to deploy.

    ```azurecli
    az group create --name rg-dp-203 --location westeurope
    az deployment group create --name dp-203 --resource-group rg-dp-203 --template-file ./automation/dp-203.bicep --parameters sqlUser=azureuser sqlPassword=$password userobjectid=$userobjectid powerBIAdminEmailAddress=$powerBIAdminEmailAddress uniqueSuffix=$uniqueSuffix
    ```

    If you get any errors (#redtext), this happens usually when you re-deploy and the dedicated pool/data explorer pool is in a paused/stopped state

    | Resource | Duration | Remarks |
    |----------|----------|---------|
    | Data Lake | 30 sec | |
    | Synapse workspace | 10 min | |
    | Dedicated pool  | 5 min | if already deployed but in paused state -> error |
    | Spark pool | 15 sec | |
    | Data explorer pool  | 13 min | if already deployed but in stopped state -> error |
    | SQL Server | 8 min | |
    | Eventhub | 1.5 min | |
    | Purview account | 4 min | |
    | Logic app | 10 sec | |
    | Cosmos DB Account | 2 min | |
    | Databricks | 3 min | |

1. Verify it creates the resources + additional managed resource groups:

    ![resource groups](./images/resource-groups.png)

1. Open the Synapse workspace and click on **Publish**. The Synapse workspace has been associated automatically with this GitHub repository, but you will still need to publish the assets into the workspace itself.

    ![publish](./images/publish.png)

1. Open the pipeline **00-setup-pipeline** and **execute** it (trigger now).
1. Validate files have been stored on the data lake container **files**/labs.