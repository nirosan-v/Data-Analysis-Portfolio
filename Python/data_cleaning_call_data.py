import pandas as pd
# Load Excel file into DataFrame
df = pd.read_excel(r"/Users/home/Documents/a.Python - Pandas/docs_to_import/Customer Call List.xlsx")

# Remove duplicates
df = df.drop_duplicates()

# Remove unnecessary columns
df = df.drop(columns="Not_Useful_Column")

# Fix last name errors
df["Last_Name"] = df["Last_Name"].str.lstrip("...").str.lstrip("/")

# Clean phone numbers: remove non-numeric characters and format
df["Phone_Number"] = df["Phone_Number"].str.replace("[^0-9]", "", regex=True)  # Remove non-numeric characters
df["Phone_Number"] = df["Phone_Number"].apply(lambda x: str(x))  # Convert to string
df["Phone_Number"] = df["Phone_Number"].apply(lambda x: f"{x[:3]}-{x[3:6]}-{x[6:10]}")  # Format phone number
df["Phone_Number"] = df["Phone_Number"].str.replace("nan--", "").str.replace("--", "")  # Clean up formatting

# Split address into separate columns
df[["Street_Address", "State", "Zip_Code"]] = df["Address"].str.split(",", n=2, expand=True)

# Simplify customer status
df["Paying Customer"] = df["Paying Customer"].replace({"Yes": "Y", "No": "N"})
df["Do_Not_Contact"] = df["Do_Not_Contact"].replace({"Yes": "Y", "No": "N"})

# Replace 'N/a' and 'NaN' with empty string
df = df.replace({"N/a": "", "NaN": ""}).fillna("")  # Fill any remaining NaN values

# Remove 'Do Not Contact' entries
df = df[df["Do_Not_Contact"] != "Y"]

# Remove entries with empty phone numbers
df = df[df["Phone_Number"] != ""]

# Reset index
df = df.reset_index(drop=True)

# Display final DataFrame
print(df)
