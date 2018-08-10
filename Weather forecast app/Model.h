//
//  Model.hpp
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#pragma once

#include "MySignal.hpp"
#include <string>
#include <map>
#include <vector>

#import "WeatherLoader.h"

typedef std::vector<std::map<std::string, std::string>> ArrayOfDict;

class Model
{
public:
    Model();
    
    MySignal onUpdate;
    
    void clearCities();
    
    void setCity(std::map<std::string, std::string> city);
    
    void getWeatherData(std::string city);
    
    void writeToJSONFile(const std::string fileName,const ArrayOfDict dataToWrite);
    ArrayOfDict readFromJSONFile(const std::string fileName);
    
    ArrayOfDict getCities();
    std::map<std::string, std::string> getCurrentCondition();

    ArrayOfDict getHoursForecast();
    ArrayOfDict getDaysForecast();
    
    void loadAllCities();
    ArrayOfDict getAllCities();
    void releaseListOfAllCities();
    
    void setUserFavoriteCities(std::map<std::string, std::string> city);
    ArrayOfDict  getUserFavoriteCities();
    
    void loadFavoriteCities();
    void saveFavoriteCities();
    
    void setNumberOfCurrentCity(int number);
    int getNumberOfCurrentCity();
    
    void nextCity();
    void previousCity();
    
    std::string weatherImageNameFromCode(long weatherCode, long hours);
private:
    
    int m_numberOfCurrentCity;
    
    std::map<std::string, std::string> m_currentCondition;
    
    ArrayOfDict m_userFavoriteCities;
    
    ArrayOfDict m_cities;
    ArrayOfDict m_allCities;
    
    ArrayOfDict m_hoursForecast;
    ArrayOfDict m_daysForecast;

    
    WeatherLoader *weatherLoader;
};