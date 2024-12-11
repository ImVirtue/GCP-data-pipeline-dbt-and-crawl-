## PROJECT NAME: BUILDING DATA PIPELINE (GLAMIRA WEBSITE) FOR ANALYTICAL PURPOSES

## Main pipeline's workflow (main_workflow.png in docs folder):
    + Receive a bson file that has 41 records of user behaviour (.bson file)
    + Store data in mongoDB (VM instance)
    + Crawl product data from the URL that is attached to the .bson file
    + Using file ipToLocation to extract the customer's location in .bson file
    + Build a Data lake (GCS bucket):
        + Store raw data files (.csv and .jsonl)
    + Build Data Warehouse (Bigquery):
        + Raw layer
        + Transformed layer
    + Build a BI system (Looker):
        + Generate insightful data from Data Warehouse


## Structure of this project:
    └───source
        ├───database
        │   └───mongodb
        ├───ecom_api
        ├───message_queue
        └───restful_api
project/
    │
    ├── crawl_data/
    │   ├── crawl_product_infor.py
    │   ├── from_ip_to_location.py
    │   ├── from_mongolocal_to_csv.py
    │
    ├── dbt_workspace/
    │   ├── dbt_project.yml
    │   ├── models/
    │       ├── dim_customer.sql
    │       ├── dim_date.sql
    │       ├── dim_location.sql
    │       ├── dim_option.sql
    │       ├── dim_product.sql
    │       ├── fact_sales.sql
    │       ├── schema.yml
    │
    ├── gcp_workflow/
    │   ├── bucket_structure.txt
    │   ├── bigquery.txt
    │   ├── README.md
    │
    ├── docs/
    │   ├── raw_layer.png
    │   ├── transformed_layer.png
    │   ├── main_workflow.png
    │
    ├── sample_data/
    │   ├── sample_data1.jsonl
    │
    ├── LICENSE
    └── README.md
