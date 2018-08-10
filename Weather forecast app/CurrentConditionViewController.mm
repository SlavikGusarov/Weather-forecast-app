//
//  CurrentConditionViewController.m
//  Weather forecast app
//
//  Created by air on 09.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//
#include "Manager.h"

#import "CurrentConditionViewController.h"

#define CURRENT_CODITION_GROUP 3

@interface CurrentConditionViewController ()
{
    Manager *_manager;
}

@property (nonatomic, assign) Manager *manager;
@property (nonatomic, assign) NSInteger hour;

@property (weak) IBOutlet NSTextField *city;
@property (weak) IBOutlet NSImageView *currentWeatherImage;

// temp_C - Temperature in degrees Celsius.
@property (weak) IBOutlet NSTextField *temperature;
// weatherDesc - Weather condition description
@property (weak) IBOutlet NSTextField *weatherDesc;
// windspeedKmph - Wind speed in kilometers per hour
@property (weak) IBOutlet NSTextField *windSpeed;
// precipMM - Precipitation in millimeters
@property (weak) IBOutlet NSTextField *precipMM;
// humidity - Humidity in percentage (%)
@property (weak) IBOutlet NSTextField *humidity;
// visibility - Visibility in kilometers
@property (weak) IBOutlet NSTextField *visibility;
// pressure - Atmospheric pressure in millibars (mb)
@property (weak) IBOutlet NSTextField *pressure;
// cloudcover - Cloud cover amount in percentage (%)
@property (weak) IBOutlet NSTextField *cloudcover;
// chanceofrain - Chance of rain (precipitation) in percentage (%).

@end

@implementation CurrentConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _manager = Manager::getInstance();
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    _hour = [components hour];
    
    if(_manager->getModel()->getUserFavoriteCities().size() == 0)
    {
        _city.stringValue = @"";
        _temperature.stringValue = @"";
        _weatherDesc.stringValue = @"";
        _windSpeed.stringValue = @"";
        _precipMM.stringValue = @"";
        _humidity.stringValue = @"";
        _visibility.stringValue = @"";
        _pressure.stringValue = @"";
        _cloudcover.stringValue = @"";
    }
    else
    {
        std::map<std::string, std::string> forecast = _manager->getModel()->getCurrentCondition();
        
        _city.stringValue = @(_manager->getModel()->getUserFavoriteCities()[_manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
    
        
        _temperature.stringValue = [NSString stringWithFormat:@"Temp: %@ ℃",
                                   @(forecast["tempC"].c_str())];
        _weatherDesc.stringValue = [NSString stringWithFormat:@"Desc: %@ ℃",
                                   @(forecast["weatherDesc"].c_str())];
        _windSpeed.stringValue = [NSString stringWithFormat:@"Wind speed: %@ Kmph",
                                 @(forecast["windspeedKmph"].c_str())];
        _precipMM.stringValue = [NSString stringWithFormat:@"Precipitation: %@ mm",
                                @(forecast["precipMM"].c_str())];
        _humidity.stringValue = [NSString stringWithFormat:@"Humidity : %@ %%",
                                @(forecast["humidity"].c_str())];
        _visibility.stringValue = [NSString stringWithFormat:@"Visibility : %@ Km",
                                  @(forecast["visibility"].c_str())];
        _pressure.stringValue = [NSString stringWithFormat:@"Pressure: %@ mb",
                                @(forecast["pressure"].c_str())];
        _cloudcover.stringValue = [NSString stringWithFormat:@"Cloud cover: %@ %%",
                                  @(forecast["cloudcover"].c_str())];

        
        long weatherCode = [@(forecast["weatherCode"].c_str()) integerValue];
        _currentWeatherImage.image = [NSImage imageNamed:@(_manager->getModel()->weatherImageNameFromCode(weatherCode, _hour).c_str())];
    }
    
    __weak __typeof(self)weakSelf = self;
    _manager->getModel()->onUpdate.connect(CURRENT_CODITION_GROUP, [weakSelf](){
        
        weakSelf.city.stringValue = @(weakSelf.manager->getModel()->getUserFavoriteCities()[weakSelf.manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
        
        std::map<std::string, std::string> forecast = weakSelf.manager->getModel()->getCurrentCondition();
        
        weakSelf.temperature.stringValue = [NSString stringWithFormat:@"Temp: %@ ℃",
                                    @(forecast["temp_C"].c_str())];
        weakSelf.weatherDesc.stringValue = [NSString stringWithFormat:@"Desc: %@",
                                    @(forecast["weatherDesc"].c_str())];
        weakSelf.windSpeed.stringValue = [NSString stringWithFormat:@"Wind speed: %@ Kmph",
                                  @(forecast["windspeedKmph"].c_str())];
        weakSelf.precipMM.stringValue = [NSString stringWithFormat:@"Precipitation: %@ mm",
                                 @(forecast["precipMM"].c_str())];
        weakSelf.humidity.stringValue = [NSString stringWithFormat:@"Humidity : %@ %%",
                                 @(forecast["humidity"].c_str())];
        weakSelf.visibility.stringValue = [NSString stringWithFormat:@"Visibility : %@ Km",
                                   @(forecast["visibility"].c_str())];
        weakSelf.pressure.stringValue = [NSString stringWithFormat:@"Pressure: %@ mb",
                                 @(forecast["pressure"].c_str())];
        weakSelf.cloudcover.stringValue = [NSString stringWithFormat:@"Cloud cover: %@ %%",
                                   @(forecast["cloudcover"].c_str())];
        
        long weatherCode = [@(weakSelf.manager->getModel()->getCurrentCondition()["weatherCode"].c_str()) integerValue];
        weakSelf.currentWeatherImage.image = [NSImage imageNamed:@(weakSelf.manager->getModel()->weatherImageNameFromCode(weatherCode, weakSelf.hour).c_str())];
        
    });
    
}
@end