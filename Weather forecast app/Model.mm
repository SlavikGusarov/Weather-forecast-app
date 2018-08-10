//
//  Model.cpp
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//



#include "Model.h"

#import <Foundation/Foundation.h>


Model::Model()
{
    weatherLoader = [[WeatherLoader alloc] init];
    
    m_numberOfCurrentCity = 0;
    this->loadFavoriteCities();
   
    m_allCities = this->readFromJSONFile("/Users/air/Desktop/Weather forecast app/cities.json");
}


std::vector<std::map<std::string, std::string>> Model::getCities()
{
    return m_cities;
}
std::map<std::string, std::string> Model::getCurrentCondition()
{
    return m_currentCondition;
}
std::map<int, std::map<std::string, std::string>> Model::getHoursForecast()
{
    return m_hoursForecast;
}
std::vector<std::map<std::string, std::string>> Model::getDaysForecast()
{
    return m_daysForecast;
}

std::vector<std::map<std::string, std::string>> Model::getAllCities()
{
    return m_allCities;
}

void Model::setCity(std::map<std::string, std::string> city)
{
    m_cities.push_back(city);
}

void Model::clearCities()
{
    m_cities.clear();
}

void Model::setUserFavoriteCities(std::map<std::string, std::string> city)
{
    m_userFavoriteCities.push_back(city);
    NSLog(@"%li",m_userFavoriteCities.size());
    if(m_userFavoriteCities.size() == 1)
    {
        getWeatherData(m_userFavoriteCities[m_numberOfCurrentCity]["name"]
                       .append(",")
                       .append(m_userFavoriteCities[m_numberOfCurrentCity]["country"]));
        onUpdate();
    }
    else
    {
         nextCity();
    }
}
std::vector<std::map<std::string, std::string>> Model::getUserFavoriteCities()
{
    return m_userFavoriteCities;
}

void Model::setNumberOfCurrentCity(int number)
{
    m_numberOfCurrentCity = number;
}
int Model::getNumberOfCurrentCity()
{
    return m_numberOfCurrentCity;
}

void Model::nextCity()
{
    if(m_userFavoriteCities.size() > 1 && m_numberOfCurrentCity < m_userFavoriteCities.size())
    {
        ++m_numberOfCurrentCity;
        getWeatherData(m_userFavoriteCities[m_numberOfCurrentCity]["name"]
                       .append(",")
                       .append(m_userFavoriteCities[m_numberOfCurrentCity]["country"]));
        onUpdate();
    }
    
}
void Model::previousCity()
{
    if(m_userFavoriteCities.size() > 1 && m_numberOfCurrentCity > 0)
    {
        --m_numberOfCurrentCity;
    
        getWeatherData(m_userFavoriteCities[m_numberOfCurrentCity]["name"]
                       .append(",")
                       .append(m_userFavoriteCities[m_numberOfCurrentCity]["country"]));
        onUpdate();
    }
}


std::vector<std::map<std::string, std::string>> Model::readFromJSONFile(const std::string filePath)
{
    NSFileManager *fileManager;
//    NSString *currentDirectoryPath;
//    
    fileManager = [NSFileManager defaultManager];
//    currentDirectoryPath = [fileManager currentDirectoryPath];
//    
//    NSString* filePath = [currentDirectoryPath stringByAppendingPathComponent:@(fileName.c_str())];
    
    if (![fileManager fileExistsAtPath:@(filePath.c_str())]) {
        NSLog(@"Error, file does not exist");
        // TODO: ERROR
        return {{{"error",{"error","File does not exist"}}}};
    }
    
    NSData* data = [NSData dataWithContentsOfFile:@(filePath.c_str())];
    
    NSError *e = nil;
    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
    
//    if (!jsonData || e)
//    {
//        NSLog(@"Error, %@", e);
//        // TODO: ERROR
//        //return {{{"1",{"error","Can't read file"}}}};
//    }
//    else
//    {
        std::vector<std::map<std::string, std::string>> result;
        std::map<std::string, std::string> map;
    
        for(NSDictionary *dict in jsonData)
        {
            for(NSString* key in dict)
            {
                map[std::string([key UTF8String])] = std::string([[dict objectForKey:key] UTF8String]);
            }
            result.push_back(map);
            map.clear();
        }
        return result;
//    }
}

void Model::writeToJSONFile(const std::string fileName,const std::vector<std::map<std::string, std::string>> dataToWrite)
{
    NSFileManager *fileManager;
    NSString *currentDirectoryPath;
    
    fileManager = [NSFileManager defaultManager];
    currentDirectoryPath = [fileManager currentDirectoryPath];
    
    NSString* filePath = [currentDirectoryPath stringByAppendingPathComponent:@(fileName.c_str())];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    
    for(auto map : dataToWrite)
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        for (auto it = map.begin(); it != map.end(); ++it){
            
            NSString * key = @(it->first.c_str());
            NSString * value = @(it->second.c_str());
            
            [dict setObject:value forKey:key];
        }
        [array addObject:dict];
    }
    


    NSError *e = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject: array
                                                   options:0
                                                     error:&e];
    // TODO: Error handler
    if (!jsonData || e)
    {
         NSLog(@"Error, %@", e);
    }
    [jsonData writeToFile:filePath atomically:NO];
}

#pragma mark - Load and Save user's favorite cities

void Model::loadFavoriteCities()
{
    NSFileManager *fileManager;
    NSString *currentDirectoryPath;
    
    fileManager = [NSFileManager defaultManager];
    currentDirectoryPath = [fileManager currentDirectoryPath];
    
    NSString* filePath = [currentDirectoryPath stringByAppendingPathComponent:@"cities.json"];
    std::vector<std::map<std::string, std::string>> temp = readFromJSONFile([filePath UTF8String]);
    if(temp.size() >= 1)
    {
        if (temp[0].find("error") == temp[0].end())
        {
            // Without errors
            m_userFavoriteCities = temp;
        }
    }
}
void Model::saveFavoriteCities()
{
    this->writeToJSONFile("cities.json", m_userFavoriteCities);
    
}

# pragma mark - Get Weather Forecast

void Model::getWeatherData(std::string city)
{
    m_currentCondition.clear();
    m_daysForecast.clear();
    m_hoursForecast.clear();
    
    std::map<std::string, std::string> temp;
    
    
    
    NSDictionary * weatherFor24hours = [weatherLoader getWeatherForDays:1
                                                                andCity: [@(city.c_str()) stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                       withTimeInterval:1];
    
    NSDictionary *currentCondition = [[weatherFor24hours objectForKey:@"current_condition"] objectAtIndex:0];
    for(NSString *key in currentCondition)
    {
        if([[currentCondition objectForKey:key] isKindOfClass: [NSString class]])
        {
            m_currentCondition[std::string([key UTF8String])] = std::string([[currentCondition objectForKey:key] UTF8String]);
        }
        else
        {
            m_currentCondition[std::string([key UTF8String])] = std::string([[[[currentCondition objectForKey:key]
                                                                                objectAtIndex:0]
                                                                               objectForKey:@"value"]
                                                                              UTF8String]);
        }
    }
    
    NSDictionary *hours = [[[weatherFor24hours objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"hourly"];
    
    int hourAsKey = 0;
    
    
    for (NSDictionary *hour in hours)
    {
        hourAsKey = [[hour objectForKey:@"time"] integerValue]/100;
        for(NSString *key in hour)
        {
            if([[hour objectForKey:key] isKindOfClass: [NSString class]])
            {

                temp[std::string([key UTF8String])] = std::string([[hour objectForKey:key] UTF8String]);
            }
            else
            {
                temp[std::string([key UTF8String])] = std::string([[[[hour objectForKey:key]
                                                                                   objectAtIndex:0]
                                                                                  objectForKey:@"value"]
                                                                                 UTF8String]);
            }
        }
        m_hoursForecast[hourAsKey] = temp;
        temp.clear();
    }
    
    NSDictionary * weatherFor14Days = [[weatherLoader getWeatherForDays:14
                                                               andCity:[@(city.c_str()) stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                      withTimeInterval:24]
                                       objectForKey:@"weather"];
    

    for (NSDictionary *day in weatherFor14Days)
    {
        temp[std::string("date")] = std::string([[day objectForKey:@"date"] UTF8String]);
        for(NSString* key in [[day objectForKey:@"hourly"] objectAtIndex:0])
        {
            if([[[[day objectForKey:@"hourly"] objectAtIndex:0] objectForKey:key] isKindOfClass: [NSString class]])
            {
                
                temp[std::string([key UTF8String])] = std::string([[[[day objectForKey:@"hourly"] objectAtIndex:0] objectForKey:key] UTF8String]);
            }
            else
            {
                temp[std::string([key UTF8String])] = std::string([[[[[[day objectForKey:@"hourly"]
                                                                       objectAtIndex:0]
                                                                      objectForKey:key]
                                                                     objectAtIndex:0]
                                                                    objectForKey:@"value"]
                                                                   UTF8String]);
            }
        }
        m_daysForecast.push_back(temp);
        temp.clear();
    }
  
}