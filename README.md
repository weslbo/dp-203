# DP-203 Setup for trainers (MCT)

Welcome to this repository, which aims to help MCT trainers to deploy a demo environment (see instructions [here](./automation/README.md)). It builds further on the work already done at the official [DP-203: Azure Data Engineer](https://github.com/MicrosoftLearning/dp-203-azure-data-engineer) git repository, which contains instructions and assets for hands-on excercises.

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

## Whiteboards and labs

Additionally, you can find below a set of mindmaps that summarize each of the Learn Modules. Click on the mindmap itself to get the SVG file. The labs contain a high-level summary of what needs to be done.

### DP-203-01-Intro to data engineering

[Introduction to data engineering on Azure](https://learn.microsoft.com/training/modules/introduction-to-data-engineering-azure/)

![mindmap](./mindmaps/01-Introduction%20to%20data%20engineering%20on%20Azure.png)

[Introduction to Azure Data Lake Storage Gen2](https://learn.microsoft.com/training/modules/introduction-to-azure-data-lake-storage/)

![mindmap](./mindmaps/02-Introduction%20to%20Azure%20Data%20Lake%20Storage%20Gen2.png)

[Introduction to Azure Synapse Analytics](https://learn.microsoft.com/training/modules/introduction-azure-synapse-analytics/)

![mindmap](./mindmaps/03-Introduction%20to%20Azure%20Synapse%20Analytics.png)

Lab 1: [Explore Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/01-Explore-Azure-Synapse.html), 90 min

1. Explore Synapse Studio
2. Ingest data with a pipeline
3. Use a serverless SQL pool to analyze data
4. Use a Spark pool to analyze data
5. Use a dedicated SQL pool to query a data warehouse
6. Explore data with a Data Explorer pool

### DP-203-02-Serverless SQL

[Use Azure Synapse serverless SQL pool to query files in a data lake](https://learn.microsoft.com/training/modules/query-data-lake-using-azure-synapse-serverless-sql-pools/)

![mindmap](./mindmaps/04-Use%20Azure%20Synapse%20serverless%20SQL%20pool%20to%20query%20files%20in%20a%20data%20lake.png)

Demo 2: [Query files using a serverless SQL pool](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/01-analyze-data-with-sql.html), 45 min

1. Query data in files
2. Access external data in a database
3. Visualize query results

[Use Azure Synapse serverless SQL pools to transform data in a data lake](https://learn.microsoft.com/training/modules/use-azure-synapse-serverless-sql-pools-for-transforming-data-lake/)

![mindmap](./mindmaps/05-Use%20Azure%20Synapse%20serverless%20SQL%20pools%20to%20transform%20data%20in%20a%20data%20lake.png)

Lab 3: [Transform data using a serverless SQL pool](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/03-Transform-data-with-sql.html), 30 min

1. Query data in files
2. Transform data using CREATE EXTERAL TABLE AS SELECT (CETAS) statements
3. Encapsulate data transformation in a stored procedure

[Create a lake database in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/create-metadata-objects-azure-synapse-serverless-sql-pools/)

![mindmap](./mindmaps/06-Create%20a%20lake%20database%20in%20Azure%20Synapse%20Analytics.png)

Demo 4: [Analyze data in a lake database](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/04-Create-a-Lake-Database.html), 45 min

1. Create a lake database (RetailDB in files/labs-dp-203/04/RetailDB)
2. Create a table (Customer + Load csv + query SQL)
3. Create a table from a database template (RetailProduct -> Product -> Load csv + query SQL)
4. Create a table from existing data (Load salesorder.csv, Create table SalesOrder, define fields, create relationships)
5. Work with lake database tables

### DP-203-03-Spark

[Analyze data with Apache Spark in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/understand-big-data-engineering-with-apache-spark-azure-synapse-analytics/)

![mindmap](./mindmaps/07-Analyze%20data%20with%20Apache%20Spark%20in%20Azure%20Synapse%20Analytics.png)

Demo 5: [Analyze data in a data lake with Spark](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/02-analyze-files-with-Spark.html), 45 min

1. Query data in files
2. Analyze data in a dataframe
3. Query data using Spark SQL
4. Visualize data with Spark

[Transform data with Spark in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/transform-data-spark-azure-synapse-analytics/)

![mindmap](./mindmaps/08-Transform%20data%20with%20Spark%20in%20Azure%20Synapse%20Analytics.png)

Lab 6: [Transform data using Spark in Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/06-Transform-Data-with-Spark.html), 30 min

1. Use a Spark notebook to transform data

[Use Delta Lake in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/use-delta-lake-azure-synapse-analytics/)

![mindmap](./mindmaps/09-Use%20Delta%20Lake%20in%20Azure%20Synapse%20Analytics.png)

Lab 7: [Use Delta Lake in Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/07-Use-delta-lake.html), 40 min

1. Create delta tables
2. Create catalog tables
3. Use delta tables for streaming data
4. Query a delta table from a serverless SQL pool

### DP-203-04-Data Warehouse

[Analyze data in a relational data warehouse](https://learn.microsoft.com/training/modules/design-multidimensional-schema-to-optimize-analytical-workloads/)

![mindmap](./mindmaps/10-Analyze%20data%20in%20a%20relational%20data%20warehouse.png)

Demo 8: [Explore a relational data warehouse](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/03-Explore-data-warehouse.html), 45 min

1. Explore the data warehouse schema
2. Query the data warehouse tables
3. Challenge - Analyze reseller sales

[Load data into a relational data warehouse](https://learn.microsoft.com/training/modules/load-optimize-data-into-relational-data-warehouse/)

![mindmap](./mindmaps/11-Load%20data%20into%20a%20relational%20data%20warehouse.png)

Lab 9: [Load Data into a Relational Data Warehouse](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/09-Load-Data-into-Data-Warehouse.html), 30 min

1. Prepare to load data
2. Load data warehouse tables
3. Perform post-load optimization

### DP-203-05-Pipelines

[Build a data pipeline in Azure Synapse Analytics](https://learn.microsoft.com/training/modules/build-data-pipeline-azure-synapse-analytics/)

![mindmap](./mindmaps/12-Build%20a%20data%20pipeline%20in%20Azure%20Synapse%20Analytics.png)

Lab 10: [Build a data pipeline in Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/10-Synpase-pipeline.html), 45 min

1. View source and destination data stores
2. Implement a pipeline
3. Debug the Data Flow
4. Publish and run the pipeline

[Use Spark Notebooks in an Azure Synapse Pipeline](https://learn.microsoft.com/training/modules/use-spark-notebooks-azure-synapse-pipeline/)

![mindmap](./mindmaps/13-Use%20Spark%20Notebooks%20in%20an%20Azure%20Synapse%20Pipeline.png)

Lab 11: [Use an Apache Spark notebook in a pipeline](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/11-Spark-nobook-in-Synapse-Pipeline.html), 30 min

1. Run a Spark notebook interactively
2. Run the notebook in a pipeline

### DP-203-06-HTAP

[Plan hybrid transactional and analytical processing using Azure Synapse Analytics](https://learn.microsoft.com/training/modules/design-hybrid-transactional-analytical-processing-using-azure-synapse-analytics/)

![mindmap](./mindmaps/14-Plan%20hybrid%20transactional%20and%20analytical%20processing%20using%20Azure%20Synapse%20Analytics.png)

[Implement Azure Synapse Link with Azure Cosmos DB](https://learn.microsoft.com/training/modules/configure-azure-synapse-link-with-azure-cosmos-db/)

![mindmap](./mindmaps/15-Implement%20Azure%20Synapse%20Link%20with%20Azure%20Cosmos%20DB.png)

Lab 14: [Use Azure Synapse Link for Azure Cosmos DB](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/14-Synapselink-cosmos.html), 35 min

1. Configure Synapse Link in Azure Cosmos DB
2. Configure Synapse Link in Azure Synapse Analytics
3. Query Azure Cosmos DB from Azure Synapse Analytics

[Implement Azure Synapse Link for SQL](https://learn.microsoft.com/training/modules/implement-synapse-link-for-sql/)

![mindmap](./mindmaps/16-Implement%20Azure%20Synapse%20Link%20for%20SQL.png)

Demo 15: [Use Azure Synapse Link for SQL](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/15-Synapse-link-sql.html), 35 min

1. Configure Azure SQL Database
2. Explore the transactional database
3. Configure Azure Synapse Link

### DP-203-07-Stream Analytics

[Get started with Azure Stream Analytics](https://learn.microsoft.com/training/modules/introduction-to-data-streaming/)

![mindmap](./mindmaps/17-Get%20started%20with%20Azure%20Stream%20Analytics.png)

Demo 17: [Get started with Azure Stream Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/17-stream-analytics.html), 15 min

```bash
rm -r dp-203 -f
git clone https://github.com/MicrosoftLearning/dp-203-azure-data-engineer dp-203
cd dp-203/Allfiles/labs/17
code setup.txt
az eventhubs namespace authorization-rule keys list --name RootManageSharedAccessKey --namespace-name events-weslbo --resource-group rg-dp-203 | jq '.primaryConnectionString'
(ctrl+s, ctrl+q)
cp setup.txt orderclient.js
npm install @azure/event-hubs | Out-Null
node ~/dp-203/Allfiles/labs/17/orderclient
```

1. View the streaming data source
2. Create an Azure Stream Analytics job
3. Create an input for the event stream
4. Create an output for the blob store
5. Create a query
6. Run the streaming job

[Ingest streaming data using Azure Stream Analytics and Azure Synapse Analytics](https://learn.microsoft.com/training/modules/ingest-streaming-data-use-azure-stream-analytics-synapse/)

![mindmap](./mindmaps/18-Ingest%20streaming%20data%20using%20Azure%20Stream%20Analytics%20and%20Azure%20Synapse%20Analytics.png)

Lab 18: [Ingest realtime data with Azure Stream Analytics and Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/18-Ingest-stream-synapse.html), 45 min

1. Ingest streaming data into a dedicated SQL pool
2. Summarize streaming data in a data lake

[Visualize real-time data with Azure Stream Analytics and Power BI](https://learn.microsoft.com/training/modules/visualize-real-time-data-azure-stream-analytics-power-bi/)

![mindmap](./mindmaps/19-Visualize%20real-time%20data%20with%20Azure%20Stream%20Analytics%20and%20Power%20BI.png)

Demo 19: [Create a realtime report with Azure Stream Analytics and Microsoft Power BI](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/19-Stream-Power-BI.html), 45 min

1. Create a Power BI workspace
2. Use Azure Stream Analytics to process streaming data
3. Visualize the streaming data in Power BI

### DP-203-08-Purview

[Introduction to Microsoft Purview](https://learn.microsoft.com/training/modules/intro-to-microsoft-purview/)

![mindmap](./mindmaps/20-Introduction%20to%20Microsoft%20Purview.png)

[Integrate Microsoft Purview and Azure Synapse Analytics](https://learn.microsoft.com/training/modules/integrate-microsoft-purview-azure-synapse-analytics/)

![mindmap](./mindmaps/21-Integrate%20Microsoft%20Purview%20and%20Azure%20Synapse%20Analytics.png)

Lab 22: [Use Microsoft Purview with Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/22-Synapse-purview.html), 40 min

1. Catalog Azure Synapse Analytics data assets in Microsoft Purview
2. Integrate Microsoft Purview with Azure Synapse Analytics

### DP-203-09-Databricks

[Explore Azure Databricks](https://learn.microsoft.com/training/modules/explore-azure-databricks/)

![mindmap](./mindmaps/22-Explore%20Azure%20Databricks.png)

Demo 23: [Explore Azure Databricks](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/23-Explore-Azure-Databricks.html), 30 min

1. Create a cluster
2. Use Spark to analyze a data file
3. Create and query a database table

[Use Apache Spark in Azure Databricks](https://learn.microsoft.com/training/modules/use-apache-spark-azure-databricks/)

![mindmap](./mindmaps/23-Use%20Apache%20Spark%20in%20Azure%20Databricks.png)

Lab 24: [Use Spark in Azure Databricks](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/24-Analyze-Files-in-Azure-Databricks.html), 45 min

1. Provision an Azure Databricks workspace
2. Create a cluster
3. Explore data using a notebook

[Run Azure Databricks Notebooks with Azure Data Factory](https://learn.microsoft.com/training/modules/run-azure-databricks-notebooks-azure-data-factory/)

![mindmap](./mindmaps/24-Run%20Azure%20Databricks%20Notebooks%20with%20Azure%20Data%20Factory.png)

Demo 25: [Use Delta Lake in Azure Databricks](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/25-Delta-lake-in-Azure-Databricks.html), 40 min

1. Provision an Azure Databricks workspace
2. Create a cluster
3. Explore data using a notebook

Demo 26: [Use a SQL Warehouse in Azure Databricks](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/26-Azure-Databricks-SQL.html), 30 min

1. View and start a SQL Warehouse
2. Create a database
3. Create a table
4. Create a query
5. Create a dashboard

Demo 27: [Automate an Azure Databricks Notebook with Azure Data Factory](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/27-Azure-Databricks-Data-Factory.html), 40 min

1. Import a notebook
2. Enable Azure Databricks integration with Azure Data Factory
3. Use a pipeline to run the Azure Databricks notebook
