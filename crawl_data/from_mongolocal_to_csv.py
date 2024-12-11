from deep_translator import GoogleTranslator
import requests
import re
import pandas as pd
from bs4 import BeautifulSoup
import asyncio
import httpx
import logging
from pymongo import MongoClient

logging.basicConfig(level=logging.INFO)

semaphore = asyncio.Semaphore(5)

def search_infor(pattern, script_tag):
    if script_tag:
        match = re.search(pattern, script_tag.string)
        if match:
            value = match.group(1)
            return value
        else:
            return ''
    else:
        return ''

async def fetch_single_url(client, url):
    try:
        async with semaphore:
            # headers = {
            #     "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
            #     "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            # }
            response = await client.get(url, follow_redirects=True)
            if response.status_code == 200:
                soup = BeautifulSoup(response.text, "html.parser")
                script_tag_language = soup.find("script", text=re.compile(r"var dfLayerOptions"))
                pattern_language = r"language:\s*'(\w+)'"
                script_tag = soup.find("script", text=re.compile(r"var react_data"))
                pattern_type = r'"product_type"\s*:\s*"([^"]+)"'
                pattern_id = r'"product_id"\s*:\s*"([^"]+)"'
                pattern_gender = r'"gender"\s*:\s*"([^"]+)"'
                language = search_infor(pattern_language, script_tag_language)

                product_id = search_infor(pattern_id, script_tag)
                product_type = search_infor(pattern_type, script_tag)
                product_name = soup.find('span', class_='base', attrs={'data-ui-id': 'page-title-wrapper'}).get_text()
                product_name = GoogleTranslator(source = language, target = 'en').translate(product_name).upper()
                product_gender = search_infor(pattern_gender, script_tag)
                
                map_id_to_info = {
                    'id': product_id,
                    'name' : product_name,
                    'gender' : product_gender,
                    'type' : product_type
                }

                collection.insert_one(map_id_to_info)
                logging.info(f"id: {product_id} is fetching to Mongo... ")
            else:
                logging.error(f"Failed when fetching {url}, Status code: {response.status_code}")
    except Exception as e:
       logging.error(e)

async def fetch_urls():
    try:
        async with httpx.AsyncClient(limits=httpx.Limits(max_connections=10)) as client:
            tasks = [fetch_single_url(client, url) for url in list_url]
            await asyncio.gather(*tasks)
    except Exception as e:
        logging.error(f"Error in fetch_urls: {e}")

if __name__ == '__main__':
    client = MongoClient('mongodb://localhost:27017')

    db = client['glamira_products']
    collection = db['test_5_somaphore']

    df = pd.read_csv('main_prod_url.csv')
    list_url = df['current_url'].tolist()
    

    asyncio.run(fetch_urls())
    print('ENDING')

    # try:
    #     result_df = pd.DataFrame(map_id_to_info)
    #     result_df.to_csv('prod_info.csv', index = False)
    # except Exception as e:z
    #     print(e)