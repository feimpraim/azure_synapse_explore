SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://feb6th23synapsecoursedl.dfs.core.windows.net/nyc-taxi-data/raw/trip_type.tsv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIELDTERMINATOR ='\t'
    ) AS [result]

USE nyc_taxi_discovery

SELECT
  *   
FROM
    OPENROWSET(
        BULK '/trip_type.tsv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR ='\t'
    ) 
AS trip_type