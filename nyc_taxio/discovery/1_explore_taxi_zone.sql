-- This is auto-generated code
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://feb6th23synapsecoursedl.dfs.core.windows.net/nyc-taxi-data/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE
    ) AS [result]


-- using abfss
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS [result]


-- Examine the dat types for the columns

EXEC sp_describe_first_result_set N'SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ''abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n''
    ) AS [result]'


-- finding the max column length for each feild of the CSV file

SELECT
    MAX(LEN(locationId)) as len_locaitonID,
    MAX(LEN(Borough)) as len_Borough,
    MAX(LEN(Zone)) as len_Zone,
    MAX(LEN(service_zone)) as len_service_zone
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS [result]


-- Use With clause to provide explicit data types

SELECT
  *
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(
LocationID SMALLINT,
Borough VARCHAR(15),
Zone VARCHAR(50),
service_zone VARCHAR(15)

)AS [result]

-- Checking if synapse is using the correct data types

EXEC sp_describe_first_result_set N'
SELECT
  *
    
FROM
    OPENROWSET(
        BULK ''abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n''
    ) 
WITH(
LocationID SMALLINT,
Borough VARCHAR(15),
Zone VARCHAR(50),
service_zone VARCHAR(15)
)AS [result]'

-- Find out the default coloation for database

SELECT name,collation_name FROM sys.databases;

-- Change colation for database 
-- Specify the colation in the with clause
SELECT
  *
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(
LocationID SMALLINT,
Borough VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
Zone VARCHAR(50) COLLATE Latin1_General_100_CI_AI_SC_UTF8,
service_zone VARCHAR(15) COLLATE Latin1_General_100_CI_AI_SC_UTF8

)AS [result]


--Create new database
--CREATE DATABASE nyc_taxi_discovery;


USE nyc_taxi_discovery;

ALTER DATABASE nyc_taxi_discovery COLLATE Latin1_General_100_CI_AI_SC_UTF8


--now since the UTF8 collation has been defived we do not have to specifiy in the select query

SELECT
  *
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
AS [result]



-- Query subset of columns
SELECT
  *
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(

Borough VARCHAR(15),
Zone VARCHAR(50)


)AS [result]

--Read data from a file with no header
SELECT
  *
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone_without_header.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(
LocationID SMALLINT,
Borough VARCHAR(15) ,
Zone VARCHAR(50) ,
service_zone VARCHAR(15) 

)AS [result]

--To specifiy the columns you want to read you can use the position of the columns
SELECT
  *
    
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone_without_header.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',

        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(

Borough VARCHAR(15) 2,
Zone VARCHAR(50) 3,
LocationID SMALLINT 1

)AS [result]

-- you can now rename the columns and choose what name you want to give specific columns

SELECT
  *   
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW =2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(

location_id SMALLINT 1,
borough VARCHAR(15)  2,
zone VARCHAR(50) 3,
service_zone VARCHAR(15) 4

)AS [result]


-- identifying errros 

SELECT
  *   
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW =2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(

location_id SMALLINT 1,
borough VARCHAR(15)  2,
zone VARCHAR(10) 3,
service_zone VARCHAR(15) 4

)AS [result]



-- Using external data sources
--you can create a data source pointing to a data 
-- external data source can only be created in databases you create not on the master database

CREATE EXTERNAL DATA SOURCE nyc_taxi_data
WITH(
    LOCATION = 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/'
)
-- FYI this data source has been dropped  below

-- Now we can use the external datasource

SELECT
  *   
FROM
    OPENROWSET(
        BULK '/raw/taxi_zone.csv',
        DATA_SOURCE ='nyc_taxi_data',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW =2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(

location_id SMALLINT 1,
borough VARCHAR(15)  2,
zone VARCHAR(50) 3,
service_zone VARCHAR(15)
)AS [result]


-- create another data source that takes you to the raw folder
-- external data source can only be created in databases you create not on the master database

CREATE EXTERNAL DATA SOURCE nyc_taxi_data_raw
WITH(
    LOCATION = 'abfss://nyc-taxi-data@feb6th23synapsecoursedl.dfs.core.windows.net/raw'
)


-- you can now test to make sure it works 
SELECT
  *   
FROM
    OPENROWSET(
        BULK '/taxi_zone.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW =2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
WITH(

location_id SMALLINT 1,
borough VARCHAR(15)  2,
zone VARCHAR(50) 3,
service_zone VARCHAR(15)
)AS [result]

-- you can drop a data source  by using the drop command

DROP EXTERNAL DATA SOURCE nyc_taxi_data

-- you can find out which storage account a data source comes from by running select

SELECT name, location FROM sys.external_data_sources
