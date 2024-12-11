
-- Use the `ref` function to select from other models
{{ config(materialized='table')}}

SELECT 
    CASE
        WHEN email_address IS NOT NULL THEN CAST(FARM_FINGERPRINT(email_address) AS STRING)
        ELSE email_address
    END AS customer_key,
    email_address as customer_email,
    ip as customer_access_ip


FROM {{source('glamira_db', 'raw_glamira')}} 
GROUP BY email_address, ip
