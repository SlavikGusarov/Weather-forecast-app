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
    void setCity(std::string city);
    void getWeatherData(std::string city);
    
    void writeToJSONFile(const std::string fileName,const std::map<std::string, std::string> dataToWrite);
    std::map<std::string, std::string> readFromJSONFile(const std::string fileName);
    
private:
    
    
    void loadCities();
    void saveCities();
    
    std::map<std::string, std::string> m_cities;
    std::map<std::string, std::string> m_currentCondition;
    std::map<int, std::map<std::string, std::string>> m_hoursForecast;
    std::vector<std::map<std::string, std::string>> m_daysForecast;
    
    WeatherLoader *weatherLoader;
};