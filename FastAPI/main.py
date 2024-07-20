from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import pickle

app = FastAPI(title="California Housing Price Prediction")

class HousingData(BaseModel):
    longitude: float
    latitude: float
    housing_median_age: float
    total_rooms: float
    total_bedrooms: float
    population: float
    households: float
    median_income: float

# Load pre-trained model
try:
    with open('model/linear_model.pkl', 'rb') as f:
        model = pickle.load(f)
except Exception as e:
    raise HTTPException(status_code=500, detail=str(e))

@app.post("/predict/")
def predict(housing_data: HousingData):
    input_data = np.array([[
        housing_data.longitude, housing_data.latitude, housing_data.housing_median_age,
        housing_data.total_rooms, housing_data.total_bedrooms, housing_data.population,
        housing_data.households, housing_data.median_income
    ]])
    prediction = model.predict(input_data)
    return {"predicted_median_house_value": prediction[0]}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
