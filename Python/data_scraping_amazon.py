#import libraries
from bs4 import BeautifulSoup
import requests
import time
import datetime

#connect to site
url = "https://www.amazon.co.uk/Funny-Data-Systems-Business-Analyst/dp/B0C4QJRSKS/ref=sr_1_2?crid=16WD90LBA52XP&dib=eyJ2IjoiMSJ9.pHZa8fK9iC7Su4-_zcK9aT0RzEelwcoIIFC4nELgjGkBlcm5Xns4ri_ifQwiLFEXfHwEUFCKxOKpc1ZBAAJ3dgCU6PmoGLLzxP7_6zyzrHmiiKM1UHyuUO5WIdh4fXOr1Dzm5kU4ucKypTRfsO-kE6yOYMahOrMvO2mxNWvz9ogMHU2KZlC2hi-Y-qRZFwkUUr6OLNnraKRPOjVVL4vM947MSZ4L1dlhRnTwt4MUBCPqz5tEjW9p0STRU3QIWX9CuhhqrA0WGehuPIGaGsoCDfENFTWJWgUv4E_uYTJypyk.RP2zPoYS2Wa53pRKu7bYXuMgoHlfsYFO5_dO4lSDzn4&dib_tag=se&keywords=funny+got+data+mis+data+systems+business+analyst+shirt&qid=1728223366&sprefix=funny+got+data+mis+data+systems+business+analyst+shir%2Caps%2C105&sr=8-2"

#user agaent - headers to simulate browser request
headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Safari/605.1.15", "X-Amzn-Trace-Id": "Root=1-670298c5-254d797327a04382438fe5cb"}

#pulling in content from web
page=requests.get(url, headers=headers)
soup1 = BeautifulSoup(page.content, "html.parser")
soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

#extracting the product title
title = soup2.find(id="productTitle").get_text()

#extracting the price
price_element = soup2.find('span', class_='a-price-whole')
fraction_element = soup2.find('span', class_='a-price-fraction')

# Combine the price parts and display
if price_element and fraction_element:
    full_price = f"£{price_element.text.strip()}{fraction_element.text.strip()}"
    fp = full_price.replace(' ', '')
    fp = fp.replace('\n', '')
    print(f"The price is: {fp}")
else:
    print("Price not found.")

#clean price by stripping unwanted characters
price = fp.strip()[1:]
print(price)

#clean title by removing newlines and leading/trailing spaces
title = title.replace('\n', '')
title = title.strip()
print(title)

#check datat types of title and price
type(title), type(price)

#automate it in the bg

#store today's date
import datetime
today = datetime.date.today()
print(today)

#prepare CSV file header and data
import csv
header = ["Title", "Price","Date"]
data = [title, price, today]

#write data to CSV
with open("amazon_web_scraper.csv","w", newline="", encoding="UTF8") as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)

#read CSV to confirm data has been written
import pandas as pd
df = pd.read_csv(r"/Users/home/Documents/a.Python - Amazon/amazon_web_scraper.csv")
print(df)

#append data to exisiting csv
with open("amazon_web_scraper.csv","a+", newline="", encoding="UTF8") as f:
    writer = csv.writer(f)
    writer.writerow(data)

#function to automate price check and append new data
def check_price():
    # reconnect to site and pull updated data
    url = "https://www.amazon.co.uk/Funny-Data-Systems-Business-Analyst/dp/B0C4QJRSKS/ref=sr_1_2?crid=16WD90LBA52XP&dib=eyJ2IjoiMSJ9.pHZa8fK9iC7Su4-_zcK9aT0RzEelwcoIIFC4nELgjGkBlcm5Xns4ri_ifQwiLFEXfHwEUFCKxOKpc1ZBAAJ3dgCU6PmoGLLzxP7_6zyzrHmiiKM1UHyuUO5WIdh4fXOr1Dzm5kU4ucKypTRfsO-kE6yOYMahOrMvO2mxNWvz9ogMHU2KZlC2hi-Y-qRZFwkUUr6OLNnraKRPOjVVL4vM947MSZ4L1dlhRnTwt4MUBCPqz5tEjW9p0STRU3QIWX9CuhhqrA0WGehuPIGaGsoCDfENFTWJWgUv4E_uYTJypyk.RP2zPoYS2Wa53pRKu7bYXuMgoHlfsYFO5_dO4lSDzn4&dib_tag=se&keywords=funny+got+data+mis+data+systems+business+analyst+shirt&qid=1728223366&sprefix=funny+got+data+mis+data+systems+business+analyst+shir%2Caps%2C105&sr=8-2"
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0.1 Safari/605.1.15",
        "X-Amzn-Trace-Id": "Root=1-670298c5-254d797327a04382438fe5cb"}
    page = requests.get(url, headers=headers)  # pulling in content from web
    soup1 = BeautifulSoup(page.content, "html.parser")
    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    title = soup2.find(id="productTitle").get_text()

    # extract, clean and display price
    price_element = soup2.find('span', class_='a-price-whole')
    fraction_element = soup2.find('span', class_='a-price-fraction')

    if price_element and fraction_element:
        full_price = f"£{price_element.text.strip()}{fraction_element.text.strip()}"
        fp = full_price.replace(' ', '')
        fp = fp.replace('\n', '')

    # clean price
    price = fp.strip()[1:]
    price=float(price)

    # clean title
    title = title.replace('\n', '')
    title = title.strip()

    # get today's date
    import datetime
    today = datetime.date.today()
    print(today)

    # prepare data and append to CSV
    import csv
    header = ["Title", "Price", "Date"]
    data = [title, price, today]
    # type(data)

    # append data to this csv
    with open("amazon_web_scraper.csv", "a+", newline="", encoding="UTF8") as f:
        writer = csv.writer(f)
        writer.writerow(data)

#run price check daily
while(True):
    check_price()
    time.sleep(86400) # runs once every 24 hours (86400 seconds)

#read the CSV file to confirm data has been appended correctly
import pandas as pd
df = pd.read_csv(r"/Users/home/Documents/a.Python - Amazon/amazon_web_scraper.csv")
print(df)
