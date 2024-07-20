import pandas as pd
from sklearn.linear_model import LinearRegression
import pickle

# Load your data
path = '../data/california_housing_train.csv'
data = pd.read_csv(path)

# Assuming these columns are features and 'median_house_value' is the target
features = data.drop('median_house_value', axis=1)
target = data['median_house_value']

# Create and train the model
model = LinearRegression()
model.fit(features, target)

# Save the model to a file
with open('linear_model.pkl', 'wb') as f:
    pickle.dump(model, f)
