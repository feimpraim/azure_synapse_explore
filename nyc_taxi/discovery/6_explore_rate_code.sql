USE nyc_taxi_discovery

SELECT
rate_code_id,
rate_code 
FROM
    OPENROWSET(
        BULK '/rate_code.json',
        DATA_SOURCE ='nyc_taxi_data_raw',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0b'
    ) WITH (
        jsonData varchar(MAX)
        ) AS rate_code
CROSS APPLY OPENJSON(jsonData)WITH(
    rate_code_id TINYINT,
    rate_code VARCHAR(30) --'$.payment_type_desc' -- 1. this will take the value of payment_type_desc and assgin to a new name called description
);