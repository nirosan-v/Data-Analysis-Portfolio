import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the CSV file into a DataFrame
df = pd.read_csv(r"/Users/home/Documents/a.Python - Pandas/docs_to_import/world_population.csv")
print(df)

# Set float display format
pd.set_option("display.float_format", lambda x: "%.2f" % x)

# Display DataFrame information and summary statistics
df.info()
df.describe()  # Quick overview of the DataFrame

# Check for null values and unique counts in each column
df.isnull().sum()
df.nunique()

# Display the top 10 countries by 2022 population
df.sort_values(by="2022 Population", ascending=False).head(10)

# Display the top 10 countries by world population percentage
df.sort_values(by="World Population Percentage", ascending=False).head(10)

# Calculate and display correlation matrix
correlation_matrix = df.corr(numeric_only=True)
sns.heatmap(correlation_matrix, annot=True)
plt.rcParams["figure.figsize"] = (20, 7)
plt.show()

# Analyse population growth by continent
continent_growth = df.groupby("Continent").mean(numeric_only=True)
print(continent_growth)  # Display average population by continent

# Filter DataFrame for Oceania
print(df[df["Continent"].str.contains("Oceania")])  # Display records for Oceania

# Display mean populations by continent sorted by 2022 population
df2 = continent_growth.sort_values(by="2022 Population", ascending=False)
print(df2)

# Transpose DataFrame for visualisation
df3 = df2.transpose()  # Switch rows and columns
df3.plot()

# Display column names
print(df.columns)

# Group by continent and select specific population years, sorting by 2022 population
df4 = df.groupby("Continent")[['1970 Population', '1980 Population', '1990 Population',
                                '2000 Population', '2010 Population', '2015 Population',
                                '2020 Population', '2022 Population']].mean(numeric_only=True).sort_values(by="2022 Population", ascending=False)

# Display and plot the DataFrame
print(df4)  # Display average population over the years by continent
df4.plot()

# Create a box plot to identify outliers
df.boxplot(figsize=(20, 10))  # Looking for outliers

# Select numeric and object data types for further analysis
numeric_data = df.select_dtypes(include="number")
object_data = df.select_dtypes(include="object")
