USE nyc_taxi_discovery

-- to read a Json file you first have to read the Json into one single colum


SELECT
*


FROM
    OPENROWSET(
        BULK '/payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b', --vertical tabulator character 
        FIELDTERMINATOR ='0x0b', 
        ROWTERMINATOR = '0x0a' -- New Line characer
    ) WITH (
        jsonData varchar(MAX)) 
    
AS payment_type

-- Once you have that you can use the Json Value to get the variouse column name:


SELECT
JSON_VALUE(jsonData, '$.payment_type')  payment_type, 
JSON_VALUE(jsonData, '$.payment_type_desc')  payment_type_desc

FROM
    OPENROWSET(
        BULK '/payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX))
    
AS payment_type

-- once you have that you want to defind the extact datatypes so you can do that using cast

SELECT
CAST(JSON_VALUE(jsonData, '$.payment_type') AS SMALLINT) payment_type, 
CAST(JSON_VALUE(jsonData, '$.payment_type_desc') as VARCHAR(15)) payment_type_desc

FROM
    OPENROWSET(
        BULK '/payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX))
    
AS payment_type




-- You can use a much better openjson funtion to read json files

SELECT
payment_type,
payment_type_desc

FROM
    OPENROWSET(
        BULK '/payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX)
        ) AS payment_type
CROSS APPLY OPENJSON(jsonData)WITH(
    payment_type SMALLINT,
    payment_type_desc VARCHAR(30)
);

-- if you want to specify or change the column names

SELECT
payment_type,
description -- 2. and you can use that new name here

FROM
    OPENROWSET(
        BULK '/payment_type.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX)
        ) AS payment_type
CROSS APPLY OPENJSON(jsonData)WITH(
    payment_type SMALLINT,
    description VARCHAR(30) '$.payment_type_desc' -- 1. this will take the value of payment_type_desc and assgin to a new name called description
);


------------------------------------------------
--Read Json data with an arrary
-----------------------------------------------

--payment type desc is an array 
-- this method gets the array manually
SELECT
CAST(JSON_VALUE(jsonData, '$.payment_type') AS SMALLINT) payment_type, 
CAST(JSON_VALUE(jsonData, '$.payment_type_desc[0].value') as VARCHAR(15)) payment_type_desc_01,
CAST(JSON_VALUE(jsonData, '$.payment_type_desc[1].value') as VARCHAR(15)) payment_type_desc_1

FROM
    OPENROWSET(
        BULK '/payment_type_array.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX))
    
AS payment_type_array



-- Better approche to get array elemenst in a json

SELECT
*
FROM
    OPENROWSET(
        BULK '/payment_type_array.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX)
        ) AS payment_type_array
CROSS APPLY OPENJSON(jsonData)
WITH(
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) as JSON
)

-- The Payment Type desc is a json and can now be expanded using the cross apply
SELECT
*
FROM
    OPENROWSET(
        BULK '/payment_type_array.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX)
        ) AS payment_type_array
CROSS APPLY OPENJSON(jsonData)
WITH(
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) as JSON
)CROSS APPLY OPENJSON(payment_type_desc) 
WITH(
    sub_type SMALLINT,
    value VARCHAR(20)
);

-- So now you can select the fields that you need and rename fiedls

SELECT
payment_type,payment_type_dec_value
FROM
    OPENROWSET(
        BULK '/payment_type_array.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    ) WITH (
        jsonData varchar(MAX)
        ) AS payment_type_array
CROSS APPLY OPENJSON(jsonData)
WITH(
    payment_type SMALLINT,
    payment_type_desc NVARCHAR(MAX) as JSON
)CROSS APPLY OPENJSON(payment_type_desc) 
WITH(
    sub_type SMALLINT,
    payment_type_dec_value VARCHAR(20) '$.value'
    
);
