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

## Whiteboards

### DP-203-01-Intro to data engineering

[Introduction to data engineering on Azure](https://learn.microsoft.com/training/modules/introduction-to-data-engineering-azure/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/01-Introduction%20to%20data%20engineering%20on%20Azure.svg)

[Introduction to Azure Data Lake Storage Gen2](https://learn.microsoft.com/training/modules/introduction-to-azure-data-lake-storage/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/02-Introduction%20to%20Azure%20Data%20Lake%20Storage%20Gen2.svg)

[Introduction to Azure Synapse Analytics](https://learn.microsoft.com/training/modules/introduction-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/03-Introduction%20to%20Azure%20Synapse%20Analytics.svg)

### DP-203-02-Serverless SQL

[Use Azure Synapse serverless SQL pool to query files in a data lake](https://learn.microsoft.com/training/modules/query-data-lake-using-azure-synapse-serverless-sql-pools/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/04-Use%20Azure%20Synapse%20serverless%20SQL%20pool%20to%20query%20files%20in%20a%20data%20lake.svg)

[Use Azure Synapse serverless SQL pools to transform data in a data lake](https://learn.microsoft.com/training/modules/use-azure-synapse-serverless-sql-pools-for-transforming-data-lake/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/05-Use%20Azure%20Synapse%20serverless%20SQL%20pools%20to%20transform%20data%20in%20a%20data%20lake.svg)

[Create a lake database in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/create-metadata-objects-azure-synapse-serverless-sql-pools/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/06-Create%20a%20lake%20database%20in%20Azure%20Synapse%20Analytics.svg)

### DP-203-03-Spark

[Analyze data with Apache Spark in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/understand-big-data-engineering-with-apache-spark-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/07-Analyze%20data%20with%20Apache%20Spark%20in%20Azure%20Synapse%20Analytics.svg)

[Transform data with Spark in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/transform-data-spark-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/08-Transform%20data%20with%20Spark%20in%20Azure%20Synapse%20Analytics.svg)

[Use Delta Lake in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/use-delta-lake-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/09-Use%20Delta%20Lake%20in%20Azure%20Synapse%20Analytics.svg)

### DP-203-04-Data Warehouse

[Analyze data in a relational data warehouse](https://learn.microsoft.com/training/modules/design-multidimensional-schema-to-optimize-analytical-workloads/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/10-Analyze%20data%20in%20a%20relational%20data%20warehouse.svg)

[Load data into a relational data warehouse](https://learn.microsoft.com/training/modules/load-optimize-data-into-relational-data-warehouse/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/11-Load%20data%20into%20a%20relational%20data%20warehouse.svg)

### DP-203-05-Pipelines

[Build a data pipeline in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/build-data-pipeline-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/12-Build%20a%20data%20pipeline%20in%20Azure%20Synapse%20Analytics.svg)

[Use Spark Notebooks in an Azure Synapse Pipeline](https://learn.microsoft.com/training/modules/use-spark-notebooks-azure-synapse-pipeline/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/13-Use%20Spark%20Notebooks%20in%20an%20Azure%20Synapse%20Pipeline.svg)

### DP-203-06-HTAP

[Plan hybrid transactional and analytical processing using Azure Synapse Analytics](https://learn.microsoft.com/training/modules/design-hybrid-transactional-analytical-processing-using-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/14-Plan%20hybrid%20transactional%20and%20analytical%20processing%20using%20Azure%20Synapse%20Analytics.svg)

[Implement Azure Synapse Link with Azure Cosmos DB](https://learn.microsoft.com/training/modules/configure-azure-synapse-link-with-azure-cosmos-db/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/15-Implement%20Azure%20Synapse%20Link%20with%20Azure%20Cosmos%20DB.svg)

[Implement Azure Synapse Link for SQL](https://learn.microsoft.com/training/modules/implement-synapse-link-for-sql/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/16-Implement%20Azure%20Synapse%20Link%20for%20SQL.svg)

### DP-203-07-Stream Analytics

[Get started with Azure Stream Analytics](https://learn.microsoft.com/training/modules/introduction-to-data-streaming/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/17-Get%20started%20with%20Azure%20Stream%20Analytics.svg)

[Ingest streaming data using Azure Stream Analytics and Azure Synapse Analytics](https://learn.microsoft.com/training/modules/ingest-streaming-data-use-azure-stream-analytics-synapse/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/18-Ingest%20streaming%20data%20using%20Azure%20Stream%20Analytics%20and%20Azure%20Synapse%20Analytics.svg)

[Visualize real-time data with Azure Stream Analytics and Power BI](https://learn.microsoft.com/training/modules/visualize-real-time-data-azure-stream-analytics-power-bi/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/19-Visualize%20real-time%20data%20with%20Azure%20Stream%20Analytics%20and%20Power%20BI.svg)

### DP-203-08-Purview

[Introduction to Microsoft Purview](https://learn.microsoft.com/training/modules/intro-to-microsoft-purview/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/20-Introduction%20to%20Microsoft%20Purview.svg)

[Integrate Microsoft Purview and Azure Synapse Analytics](https://learn.microsoft.com/training/modules/integrate-microsoft-purview-azure-synapse-analytics/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/21-Integrate%20Microsoft%20Purview%20and%20Azure%20Synapse%20Analytics.svg)

### DP-203-09-Databricks

[Explore Azure Databricks](https://learn.microsoft.com/training/modules/explore-azure-databricks/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/22-Explore%20Azure%20Databricks.svg)

[Use Apache Spark in Azure Databricks](https://learn.microsoft.com/training/modules/use-apache-spark-azure-databricks/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/23-Use%20Apache%20Spark%20in%20Azure%20Databricks.svg)

[Run Azure Databricks Notebooks with Azure Data Factory](https://learn.microsoft.com/training/modules/run-azure-databricks-notebooks-azure-data-factory/)

![mindmap](https://raw.githubusercontent.com/weslbo/dp-203/main/mindmaps/24-Run%20Azure%20Databricks%20Notebooks%20with%20Azure%20Data%20Factory.svg)


## Labs

see [labs](./labs_demos.md) for a list of labs and demos