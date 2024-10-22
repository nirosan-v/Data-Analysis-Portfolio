from bs4 import BeautifulSoup
import requests
import pandas as pd

# Fetch the Wikipedia page
url = "https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue"
page = requests.get(url)
soup = BeautifulSoup(page.text, "html.parser")  # Use "html.parser" for correct parsing

# Locate the first table on the page
table = soup.find_all("table")[0]
print(table)

# Extract and clean up the table headers
titles = soup.find_all("th")[0:7]
titles_table = [title.text.strip().replace("[note 1]", "") for title in titles]
print(titles_table)

# Create an empty DataFrame with the extracted column names
df = pd.DataFrame(columns=titles_table)

# Extract the rows of the table
column_data = table.find_all("tr")

# Populate the DataFrame with table data (limit to 50 rows)
counter = 1
for row in column_data:
    if counter > 50:  # Stop after 50 rows
        break

    row_data = row.find_all("td")
    if len(row_data) >= 6:  # Ensure the row has enough columns
        individual_row_data = [data.text.strip() for data in row_data][0:6]
        individual_row_data = [counter] + individual_row_data  # Add a counter as the first column
        counter += 1

        df.loc[len(df)] = individual_row_data  # Append the row to the DataFrame

# Display the resulting DataFrame
print(df)

# Save the DataFrame to a CSV file
df.to_csv(r"/Users/home/Documents/a.Python - HTML:Web Scraping/Top_50_Companies.csv", index=False)
