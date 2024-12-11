
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with parsed_data AS (
    SELECT 
        JSON_EXTRACT_ARRAY(cart_products) AS product_array,
    FROM {{source('glamira_db', 'raw_glamira')}} r
    LEFT JOIN {{source('glamira_db', 'raw_ip2location')}}lc ON r.ip = lc.string_field_0
    WHERE collection = 'checkout_success'
),
flattened_data AS (
    SELECT 
        JSON_EXTRACT_ARRAY(product, '$.option') AS option_array,
    FROM parsed_data, UNNEST(product_array) AS product 
),

final as(
  SELECT
    JSON_EXTRACT_SCALAR(options,'$.option_id') AS option_id,
    JSON_EXTRACT_SCALAR(options,'$.option_label') AS option_value,
    from flattened_data, UNNEST(option_array) AS options
    GROUP BY option_id, option_value
)

SELECT * FROM final