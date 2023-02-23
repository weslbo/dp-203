# Modules + Lab/Demo flow

## DP-203-00-Setup

No demo: Run pipeline, Scripts to setup environment

## DP-203-01-Intro to data engineering

Lab 1: [Explore Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/01-Explore-Azure-Synapse.html), 90 min

1. Explore Synapse Studio
2. Ingest data with a pipeline
3. Use a serverless SQL pool to analyze data
4. Use a Spark pool to analyze data
5. Use a dedicated SQL pool to query a data warehouse
6. Explore data with a Data Explorer pool

## DP-203-02-Serverless SQL

Demo 2: [Query files using a serverless SQL pool](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/01-analyze-data-with-sql.html), 45 min

1. Query data in files
2. Access external data in a database
3. Visualize query results

Lab 3: [Transform data using a serverless SQL pool](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/03-Transform-data-with-sql.html), 30 min

1. Query data in files
2. Transform data using CREATE EXTERAL TABLE AS SELECT (CETAS) statements
3. Encapsulate data transformation in a stored procedure

Demo 4: [Analyze data in a lake database](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/04-Create-a-Lake-Database.html), 45 min

1. Create a lake database (RetailDB in files/labs-dp-203/04/RetailDB)
2. Create a table (Customer + Load csv + query SQL)
3. Create a table from a database template (RetailProduct -> Product -> Load csv + query SQL)
4. Create a table from existing data (Load salesorder.csv, Create table SalesOrder, define fields, create relationships)
5. Work with lake database tables

## DP-203-03-Spark

Demo 5: [Analyze data in a data lake with Spark](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/02-analyze-files-with-Spark.html), 45 min

1. Query data in files
2. Analyze data in a dataframe
3. Query data using Spark SQL
4. Visualize data with Spark

Lab 6: [Transform data using Spark in Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/06-Transform-Data-with-Spark.html), 30 min

1. Use a Spark notebook to transform data

Lab 7: [Use Delta Lake in Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/07-Use-delta-lake.html), 40 min

1. Create delta tables
2. Create catalog tables
3. Use delta tables for streaming data
4. Query a delta table from a serverless SQL pool

## DP-203-04-Data Warehouse

Demo 8: [Explore a relational data warehouse](https://microsoftlearning.github.io/DP-500-Azure-Data-Analyst/Instructions/labs/03-Explore-data-warehouse.html), 45 min

1. Explore the data warehouse schema
2. Query the data warehouse tables
3. Challenge - Analyze reseller sales

Lab 9: [Load Data into a Relational Data Warehouse](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/09-Load-Data-into-Data-Warehouse.html), 30 min

1. Prepare to load data
2. Load data warehouse tables
3. Perform post-load optimization

## DP-203-05-Pipelines

Lab 10: [Build a data pipeline in Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/10-Synpase-pipeline.html), 45 min

1. View source and destination data stores
2. Implement a pipeline
3. Debug the Data Flow
4. Publish and run the pipeline

Lab 11: [Use an Apache Spark notebook in a pipeline](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/11-Spark-nobook-in-Synapse-Pipeline.html), 30 min

1. Run a Spark notebook interactively
2. Run the notebook in a pipeline

## DP-203-06-HTAP

Lab 14: [Use Azure Synapse Link for Azure Cosmos DB](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/14-Synapselink-cosmos.html), 35 min

1. Configure Synapse Link in Azure Cosmos DB
2. Configure Synapse Link in Azure Synapse Analytics
3. Query Azure Cosmos DB from Azure Synapse Analytics

Demo 15: [Use Azure Synapse Link for SQL](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/15-Synapse-link-sql.html), 35 min

1. Configure Azure SQL Database
2. Explore the transactional database
3. Configure Azure Synapse Link

## DP-203-07-Stream Analytics

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

Lab 18: [Ingest realtime data with Azure Stream Analytics and Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/18-Ingest-stream-synapse.html), 45 min

1. Ingest streaming data into a dedicated SQL pool
2. Summarize streaming data in a data lake

Demo 19: [Create a realtime report with Azure Stream Analytics and Microsoft Power BI](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/19-Stream-Power-BI.html), 45 min

1. Create a Power BI workspace
2. Use Azure Stream Analytics to process streaming data
3. Visualize the streaming data in Power BI

## DP-203-08-Purview

Lab 22: [Use Microsoft Purview with Azure Synapse Analytics](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/22-Synapse-purview.html), 40 min

1. Catalog Azure Synapse Analytics data assets in Microsoft Purview
2. Integrate Microsoft Purview with Azure Synapse Analytics

## DP-203-09-Databricks

Demo 23: [Explore Azure Databricks](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/23-Explore-Azure-Databricks.html), 30 min

1. Create a cluster
2. Use Spark to analyze a data file
3. Create and query a database table

Lab 24: [Use Spark in Azure Databricks](https://microsoftlearning.github.io/dp-203-azure-data-engineer/Instructions/Labs/24-Analyze-Files-in-Azure-Databricks.html), 45 min

1. Provision an Azure Databricks workspace
2. Create a cluster
3. Explore data using a notebook

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
