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
    
    std::map<std::string, std::string> data = {{"city","Odessa"}};
    this->writeToJSONFile("cities.json", data);
    
    m_cities = this->readFromJSONFile("cities.json");
}


std::map<std::string, std::string> Model::readFromJSONFile(const std::string fileName)
{
    NSFileManager *fileManager;
    NSString *currentDirectoryPath;
    
    fileManager = [NSFileManager defaultManager];
    currentDirectoryPath = [fileManager currentDirectoryPath];
    
    NSString* filePath = [currentDirectoryPath stringByAppendingPathComponent:@(fileName.c_str())];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        return {{"error","File does not exist"}};
    }
    
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *e = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];

    // TODO: Error handler
    
    std::map<std::string, std::string> map;
    
    for(NSString *key in result)
    {
        //map.emplace(std::string([key UTF8String]), std::string([[result objectForKey:key] UTF8String]));
        map[std::string([key UTF8String])] = std::string([[result objectForKey:key] UTF8String]);
    }
    return map;
}

void Model::writeToJSONFile(const std::string fileName,const std::map<std::string, std::string> dataToWrite)
{
    NSFileManager *fileManager;
    NSString *currentDirectoryPath;
    
    fileManager = [NSFileManager defaultManager];
    currentDirectoryPath = [fileManager currentDirectoryPath];
    
    NSString* filePath = [currentDirectoryPath stringByAppendingPathComponent:@(fileName.c_str())];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    for (auto it = dataToWrite.begin(); it != dataToWrite.end(); ++it){
        
        NSString * key = @(it->first.c_str());
        NSString * value = @(it->second.c_str());
        
        [dict setObject:value forKey:key];
        
        NSLog(@"NSDictonaryFromMap() - key:%@ value:%@", key, value);
    }

    NSError *e = nil;
    NSData* json = [NSJSONSerialization dataWithJSONObject: dict
                                                   options:0
                                                     error:&e];
    // TODO: Error handler
    [json writeToFile:filePath atomically:NO];
}


void Model::loadCities()
{

}



void Model::saveCities()
{

}

void Model::getWeatherData(std::string city)
{
    std::map<std::string, std::string> temp;
    
    NSDictionary * weatherFor24hours = [weatherLoader getWeatherForDays:1
                                                                andCity:@"Odessa,ua"
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
                                                               andCity:@"Odessa,ua"
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
    NSLog(@"Boom");
}