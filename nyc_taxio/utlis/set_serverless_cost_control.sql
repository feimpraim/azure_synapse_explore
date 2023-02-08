SElECT * FROM sys.dm_external_data_processed

SELECT * FROM sys.configurations
WHERE name LIKE 'Data Processed %'

/* Set the Limits for data processing. */
sp_set_data_processed_limit
    @type = N'monthly',
    @limit_tb = 2;


sp_set_data_processed_limit
    @type = N'monthly',
    @limit_tb = 1;

sp_set_data_processed_limit
    @type = N'monthly',
    @limit_tb = 1;