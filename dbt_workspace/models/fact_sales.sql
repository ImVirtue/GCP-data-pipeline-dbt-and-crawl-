
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with parsed_data AS (
    SELECT 
        GENERATE_UUID() as order_id,
        JSON_EXTRACT_ARRAY(cart_products) AS product_array,
        case
            when email_address is not null then CAST(FARM_FINGERPRINT(email_address) AS STRING)
            else email_address
        end as customer_key,
        device_id,
        local_time,
        CAST(FARM_FINGERPRINT(CONCAT(string_field_1, string_field_2)) AS STRING) as location_key
    FROM {{source('glamira_db', 'raw_glamira')}} r
    LEFT JOIN {{source('glamira_db', 'raw_ip2location')}}lc ON r.ip = lc.string_field_0
    WHERE collection = 'checkout_success'
),
flattened_data AS (
    SELECT 
        order_id,
        device_id,
        location_key,
        customer_key,
        DATETIME (local_time) as datetime_value,
        JSON_EXTRACT_SCALAR(product, '$.product_id') AS product_id,
        JSON_EXTRACT_SCALAR(product, '$.price') AS price,
        JSON_EXTRACT_SCALAR(product, '$.amount') AS amount,
        JSON_EXTRACT_ARRAY(product, '$.option') AS option_array,
        JSON_EXTRACT_SCALAR(product, '$.currency') AS currency
    FROM parsed_data, UNNEST(product_array) AS product 
),

fact_sales as(
  SELECT
    ROW_NUMBER() OVER() as sales_order_line_id,
    order_id as sales_order_id,
    device_id,
    location_key,
    product_id,
    JSON_EXTRACT_SCALAR(options,'$.option_id') AS option_id,
    customer_key,
    DATE(TIMESTAMP(datetime_value))AS order_time,
    amount as unit_quantity,
    price,
    currency,
    from flattened_data, UNNEST(option_array) AS options
)

SELECT * FROM fact_sales