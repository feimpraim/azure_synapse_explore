
USE nyc_taxi_discovery

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/month=01/green_tripdata_2020-01.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data


-- Selecting data from a folder

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/month=01/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data







-- Selecting data from sub folders
--Use double start to get subfolder

    SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=2020/**',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data


    -- Get dat from more than 1 file

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK ('trip_data_green_csv/year=2020/month=01/*.csv',
        'trip_data_green_csv/year=2020/month=03/*.csv'),
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data


-- use more than 1 wildcard character
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data


    -- File metadata function filename()

SELECT
    TOP 100 
    green_trip_data.filename() as file_name,
    green_trip_data.*
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data


--Getting how many records are in each file

SELECT
    green_trip_data.filename() as file_name,
    count(1) as row_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data
    GROUP by green_trip_data.filename()
    ORDER by green_trip_data.filename()




    -- limit data using filename() / Getting data from a specific file / or multiple files

SELECT
    green_trip_data.filename() as file_name,
    count(1) as row_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data
    WHERE green_trip_data.filename() in ('green_tripdata_2020-01.csv','green_tripdata_2020-02.csv','green_tripdata_2020-11.csv')
    GROUP by green_trip_data.filename()
    ORDER by green_trip_data.filename()

    -- gettingt the file path of the file using the filepath funtion

    SELECT
    green_trip_data.filename() as file_name,
    green_trip_data.filepath() as file_path,
    count(1) as row_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data
    WHERE green_trip_data.filename() in ('green_tripdata_2020-01.csv','green_tripdata_2020-02.csv','green_tripdata_2020-11.csv')
    GROUP by green_trip_data.filename(),green_trip_data.filepath()
    ORDER by green_trip_data.filename(),green_trip_data.filepath()

/*gettingt the file path of the file using the filepath funtion the file path can take 
numeric parameters that corresposnd to the the position of the wildcart character

*/
    SELECT
    green_trip_data.filename() as file_name,
    green_trip_data.filepath(1) as year_from_file_name,
    green_trip_data.filepath(2) as month_from_file_name,
    green_trip_data.filepath(3) as full_file_name,
    count(1) as row_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data
    WHERE green_trip_data.filename() in ('green_tripdata_2020-01.csv','green_tripdata_2020-02.csv','green_tripdata_2020-11.csv')
    GROUP BY green_trip_data.filename(),green_trip_data.filepath(1)
    ,green_trip_data.filepath(2)
    ,green_trip_data.filepath(3)
    ORDER by green_trip_data.filename(),green_trip_data.filepath(1)


-- using this informaiton we can get all the data with the file names included.
SELECT
    TOP 100 
    green_trip_data.filename() as file_name,
    green_trip_data.filepath(1) as year_from_file_name,
    green_trip_data.filepath(2) as month_from_file_name,
    green_trip_data.filepath(3) as full_file_name,
    green_trip_data.*
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data

-- if you want to get the trip count for each month you can do that 


    SELECT
    green_trip_data.filepath(1) as year_from_file_name,
    green_trip_data.filepath(2) as month_from_file_name,
    count(1) as row_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data
    GROUP BY green_trip_data.filename(),green_trip_data.filepath(1)
    ,green_trip_data.filepath(2)
order by count(1) 

-- you can filter by the filepath also lets say to get only trips from june july and august 2020



  SELECT
    green_trip_data.filepath(1) as year_from_file_name,
    green_trip_data.filepath(2) as month_from_file_name,
    count(1) as row_count
FROM
    OPENROWSET(
        BULK 'trip_data_green_csv/year=*/month=*/*.csv',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW =TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS green_trip_data
    WHERE green_trip_data.filepath(1) ='2020' AND green_trip_data.filepath(2) IN ('06','07','08')
    GROUP BY green_trip_data.filename(),green_trip_data.filepath(1)
    ,green_trip_data.filepath(2)
order by count(1) 