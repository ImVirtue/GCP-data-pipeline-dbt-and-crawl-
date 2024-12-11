Read this file to have an overview about the GCP services that are used for this project

- VM instace:
    + Using VM instace as a venue to store data file (.bson file with 41M records about user behavior):
        + Connect VM with local machine (.bson file is in local machine)
        + Using gcp service to transfer .bson file to VM
        + Allocate reasonably disks in VM to save data
        + Install a MongoDB in VM
        + Using mongostore command on Ubuntu VM to load data from file to MongoDB
        + revise firewall rules to be able to access from local Machine
        + Split data file into smaller files to be ready to transfer to GCS bucket

- Google cloud storage bucket (more detailed in bucket_structure.txt file):
    + Using bucket on GCS as a DataLake to store raw data (.json files) from MongoDB

- Google Bigquery (more detailed in bigquery.txt file): 
    + Use Google Bigquery as a Data Warehouse to process data
    + Create schema structure for Data Warehouse to receive data from GCS bucket (.json files)
    + Create DBT project to generate data modeling from raw to transformed layer (in dbt_workspace folder)

- Looker Studio:
    + Use Looker as a BI tool for creating insighful dashboard about revenue, user behavior, product,...