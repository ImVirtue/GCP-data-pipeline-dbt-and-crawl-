import IP2Location
import os
import pandas as pd

database = IP2Location.IP2Location("IP-COUNTRY-REGION-CITY.BIN")

from pymongo import MongoClient

# mongo_username = "<your_username>"
# mongo_password = "<your_password>"
mongo_host = '34.41.217.45'
mongo_port = 27017  # default MongoDB port
mongo_db = "glamira_database"

uri = f"mongodb://{mongo_host}:{mongo_port}/{mongo_db}"
# uri = f"mongodb://'34.41.217.45':27017/'glamira_database'"


# Connect to MongoDB
try:
    client = MongoClient(uri)
    print("Connected to MongoDB!")
    
    # Access a database and collection (example)
    db = client[mongo_db]
    collection = db["glamira_collection"]
    result = collection.aggregate([
        {'$group': {'_id': '$ip'}}  
    ])
    list_ip = [doc['_id'] for doc in result]
    # Querying the collection (example)
    document = collection.find_one({"store_id": "12"})
    
except Exception as e:
    print(f"Error connecting to MongoDB: {e}")

map_ip = {
    'ip' : [],
    'country' : [],
    'city' : []
 }

for ip in list_ip:
    map_ip['ip'].append(ip)
    map_ip['country'].append(database.get_country_long(ip))
    map_ip['city'].append(database.get_city(ip))
    print('Getting location data!')


df_ip_to_location = pd.DataFrame(map_ip)
df_ip_to_location.to_csv('ip_to_location.csv', index= False)


