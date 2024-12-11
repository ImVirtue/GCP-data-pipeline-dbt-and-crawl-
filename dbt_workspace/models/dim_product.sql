
-- Use the `ref` function to select from other models
{{ config(materialized='table') }}

SELECT 
    id AS product_id,
    name AS product_name,
    type AS product_type,
    gender AS product_gender,
FROM {{source('glamira_db', 'raw_prod_information')}} r
