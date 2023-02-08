-- This is auto-generated code
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://feb6th23synapsecoursedl.dfs.core.windows.net/nyc-taxi-data/raw/calendar.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0'
    ) AS [result]



--Working on a samply examply to quey CSV

SELECT
  *   
FROM
    OPENROWSET(
        BULK '/calendar.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
       -- FIRSTROW =2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
AS [result]

-- Checking to determine the data types

EXEC sp_describe_first_result_set N'SELECT
  *   
FROM
    OPENROWSET(
        BULK ''/calendar.csv'',
        DATA_SOURCE =''nyc_taxi_data_raw'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW =TRUE,
       -- FIRSTROW =2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n''
    ) 
AS [result]'

-- setting correct data types

SELECT
  *   
FROM
    OPENROWSET(
        BULK '/calendar.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE
      -- FIRSTROW =1,
       -- FIELDTERMINATOR = ',',
      --  ROWTERMINATOR = '\n'
    ) 
    WITH(
    date_key        INT ,
    date            DATE ,
    year            SMALLINT ,
    month           TINYINT ,
    day             TINYINT ,
    day_name        VARCHAR(30) ,
    day_of_year     SMALLINT ,
    week_of_month   TINYINT ,
    week_of_year    TINYINT ,
    month_name      VARCHAR(30) ,
    year_month      INT ,
    year_week       INT 
    )
AS [result]

---



