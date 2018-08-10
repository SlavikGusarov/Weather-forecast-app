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
   
    //m_allCities = this->readFromJSONFile("/Users/air/Desktop/Weather forecast app/cities.json");
}


std::vector<std::map<std::string, std::string>> Model::getCities()
{
    return m_cities;
}
std::map<std::string, std::string> Model::getCurrentCondition()
{
    return m_currentCondition;
}
std::vector<std::map<std::string, std::string>> Model::getHoursForecast()
{
    return m_hoursForecast;
}
std::vector<std::map<std::string, std::string>> Model::getDaysForecast()
{
    return m_daysForecast;
}

void Model::loadAllCities()
{
    m_allCities = readFromJSONFile("/Users/air/Desktop/Weather forecast app/cities.json");
}

std::vector<std::map<std::string, std::string>> Model::getAllCities()
{
    return m_allCities;
}

void Model::releaseListOfAllCities()
{
    m_allCities.clear();
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
        getWeatherData(m_userFavoriteCities[m_numberOfCurrentCity]["name"]);
        onUpdate();
    }
    
}
void Model::previousCity()
{
    if(m_userFavoriteCities.size() > 1 && m_numberOfCurrentCity > 0)
    {
        --m_numberOfCurrentCity;
    
        getWeatherData(m_userFavoriteCities[m_numberOfCurrentCity]["name"]);
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
    NSLog(@"%@", @(city.c_str()));
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
        NSLog(@"%@",[hour objectForKey:@"time"]);
        // If "time"
        if([[hour objectForKey:@"time"] isEqualToString:@"24"])
        {
            continue;
        }
        
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
        temp["time"] = std::string([[hour objectForKey:@"time"] UTF8String]);
        m_hoursForecast.push_back(temp);
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


std::string Model::weatherImageNameFromCode(long weatherCode, long hours)
{
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
    switch (weatherCode) {
        case 113:
        {
            // Clear
            if (hours > 5 && hours < 21)
            {
                return  "113";
            }
            return "113night";
        }
        case 116:
        {
            // Partly Cloudy
            if (hours > 5 && hours < 21)
            {
                return "116";
            }
            return "116night";
        }
        case 119:
        {
            // Cloudy
            return "119";
        }
        case 122:
        {
            // Overcast
            if (hours > 5 && hours < 21)
            {
                return "122";
            }
            return "122night";
        }
        case 143:
        case 248:
        case 260:
        {
            // Fog
            if (hours > 5 && hours < 21)
            {
                return "143";
            }
            return "143night";
        }
        case 176:
        case 263:
        case 266:
        case 293:
        case 296:
        case 353:
        case 362:
        case 368:
        case 374:
        {
            // Light rain
            if (hours > 5 && hours < 21)
            {
                return "176";
            }
            return "176night";
        }
        case 200:
        case 395:
        case 392:
        case 389:
        case 386:
        {
            // Thunder
            return "200";
        }
        case 302:
        case 308:
        case 305:
        case 299:
        case 311:
        case 359:
        case 356:
        case 365:
        case 371:
        case 377:
        {
            // Heavy rain
            return "302";
        }
        case 179:
        case 182:
        case 317:
        case 185:
        case 329:
        case 326:
        case 323:
        {
            // Light snow
            return "179";
        }
        case 227:
        case 230:
        case 350:
        case 338:
        case 335:
        case 332:
        case 320:
        {
            // Heavy snow
            return "227";
        }
        case 281:
        case 314:
        case 284:
        {
            // Freeze
            return "281";
        }
        default:
        {
            return "default";
        }
    }
}
