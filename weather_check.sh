#!/bin/bash

# Prompt user for the city
echo "Enter a city to get the weather:"
read city

# Replace with your actual API key from OpenWeatherMap
api_key="your_api_key_here"

# Fetch weather data from OpenWeatherMap API
weather=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$api_key&units=metric")

# Check if the weather data was fetched successfully
if [[ $(echo "$weather" | jq -r '.cod') != "200" ]]; then
    echo "Error: Unable to get weather data for $city."
    exit 1
fi

# Extract the temperature from the weather data
temp=$(echo $weather | jq '.main.temp')

# If the temperature is empty or invalid, default to 0
if [ -z "$temp" ]; then
    temp="0"
fi

# Display the temperature
echo "The current temperature in $city is $temp°C."
