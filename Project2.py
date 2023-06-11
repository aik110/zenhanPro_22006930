import pandas as pd
import numpy as np


# Load data
pwt1001 = pd.read_stata('https://dataverse.nl/api/access/datafile/354098')

# Filter and select relevant columns
data = pwt1001.loc[pwt1001['country'].isin(["Australia", "Austria"])][['year', 'countrycode', 'rgdpna', 'rkna', 'emp', 'labsh']]
data = data.loc[(data['year'] >= 1995) & (data['year'] <= 2019)].dropna()

# Calculate additional columns
data['y_pc'] = np.log(data['rgdpna'] / data['emp'])  # GDP per worker
data['k_pc'] = np.log(data['rkna'] / data['emp'])  # Capital per worker
data['a'] = 1 - data['labsh']  # Capital share

# Order by year
data = data.sort_values('year')

# Group by isocode
grouped_data = data.groupby('countrycode')

# Calculate growth rates and Solow residual
data['g'] = (grouped_data['y_pc'].diff() * 100)  # Growth rate of GDP per capita

# Remove missing values
data = data.dropna()

# Calculate summary statistics
summary = data.groupby('countrycode').agg({'g': 'mean',
                                       'a': "mean"})

# Calculate additional summary statistics
summary['Growth Rate'] = summary['g']
summary['Capital Share'] = summary['a']

# Print output
print(summary)