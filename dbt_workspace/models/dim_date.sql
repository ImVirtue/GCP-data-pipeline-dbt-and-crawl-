
-- Use the `ref` function to select from other models
{{ config(materialized='table')}}

WITH full_date AS (
    SELECT 
        * 
    FROM 
        UNNEST(GENERATE_DATE_ARRAY(
            DATE '2019-01-01', 
            DATE '2021-12-31', 
            INTERVAL 1 DAY
        )) AS date_value
)

SELECT 
  date_value,                                  
  CASE 
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 1 THEN 'Sunday' 
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 2 THEN 'Monday'
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 3 THEN 'Tuesday'
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 4 THEN 'Wednesday'
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 5 THEN 'Thursday'
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 6 THEN 'Friday'
    WHEN EXTRACT(DAYOFWEEK FROM date_value) = 7 THEN 'Saturday'
  END AS day_of_week,                           
  CASE 
    WHEN EXTRACT(DAYOFWEEK FROM date_value) IN (1, 7) THEN TRUE 
    ELSE FALSE 
  END AS is_weekend,                         
  EXTRACT(DAY FROM date_value) AS day_of_month 
  EXTRACT(MONTH FROM date_value) AS month,     
  EXTRACT(DAYOFYEAR FROM date_value) AS day_of_the_year
  EXTRACT(WEEK FROM date_value) AS week_of_the_year,    
  EXTRACT(QUARTER FROM date_value) AS quarter,         
  EXTRACT(YEAR FROM date_value) AS year                
FROM 
  full_date
ORDER BY 
  date_value

