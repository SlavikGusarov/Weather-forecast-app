//
//  Model.hpp
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#pragma once

#include "IModelable.h"
#include <string>
#include <map>
#include <vector>

#import "WeatherLoader.h"

class Model : IModelable
{
    // 1. Пользователь выбирает и добавляет три города
    //    Нужно сохранить их в json и загружать, при каждом запуске
    
    // 2. При запуске приложения в фоне (асинхронно) загружается погода
    //    на сегодня и 14 дней вперед
    
public:
    Model();
    
    void clearCities();
    
    void setCity(std::map<std::string, std::string> city);
    void getWeatherData(std::string city);
    
    void writeToJSONFile(const std::string fileName,const std::map<std::string, std::string> dataToWrite);
    std::vector<std::map<std::string, std::string>> readFromJSONFile(const std::string fileName);
    
    std::vector<std::map<std::string, std::string>> getCities();
    std::map<std::string, std::string> getCurrentCondition();
    // TODO : Make hourforecast vector
    std::map<int, std::map<std::string, std::string>> getHoursForecast();
    std::vector<std::map<std::string, std::string>> getDaysForecast();
    std::vector<std::map<std::string, std::string>>  getAllCities();
private:
    
    
    void loadCities();
    void saveCities();
    
    
    std::map<std::string, std::string> m_currentCondition;
    

    std::vector<std::map<std::string, std::string>> m_cities;
    std::map<int, std::map<std::string, std::string>> m_hoursForecast;
    std::vector<std::map<std::string, std::string>> m_daysForecast;
    std::vector<std::map<std::string, std::string>> m_allCities;
    
    WeatherLoader *weatherLoader;
    
    /*
     weatherCode:
     ----------
     395 - Moderate or heavy snow in area with thunder
     392 - Patchy light snow in area with thunder
     389 - Moderate or heavy rain in area with thunder
     386 - Patchy light rain in area with thunder
     ----------
     314 - Moderate or Heavy freezing rain
     284 - Heavy freezing drizzle
     281 - Freezing drizzle
     ---------
     230 - Blizzard
     227 - Blowing snow
     350 - Ice pellets
     338 - Heavy snow
     335 - Patchy heavy snow
     332 - Moderate snow
     320 - Moderate or heavy sleet
     ---------
     317 - Light sleet
     185 - Patchy freezing drizzle nearby
     182 - Patchy sleet nearby
     179 - Patchy snow nearby
     329 - Patchy moderate snow
     326 - Light snow
     323 - Patchy light snow
     --------
     308 - Heavy rain
     305 - Heavy rain at times
     302 - Moderate rain
     299 - Moderate rain at times
     311 - Light freezing rain
     359 - Torrential rain shower
     356 - Moderate or heavy rain shower
     365 - Moderate or heavy sleet showers
     371 - Moderate or heavy snow showers
     377 - Moderate or heavy showers of ice pellets
     ---------
     200 - Thundery outbreaks in nearby
     ---------
     263 - Patchy light drizzle
     176 - Patchy rain nearby
     266 - Light drizzle
     293 - Patchy light rain
     296 - Light rain
     353 - Light rain shower
     362 - Light sleet showers
     368 - Light snow showers
     374 - Light showers of ice pellets
     ---------
     143 - Mist
     248 - Fog
     260 - Freezing fog
     --------
     122 - Overcast
     --------
     119 - Cloudy
     --------
     116 - Partly Cloudy
     --------
     113 - Clear/Sunny
     */
};