
-- Use the `ref` function to select from other models
{{ config(materialized='table')}}

SELECT 
    CAST(FARM_FINGERPRINT(CONCAT(string_field_1, string_field_2)) AS STRING) AS location_key,
    string_field_1 AS country,
    string_field_2 AS city

FROM {{source('glamira_db', 'raw_ip2location')}} 
GROUP BY  CAST(FARM_FINGERPRINT(CONCAT(string_field_1, string_field_2)) AS STRING), string_field_1, string_field_2