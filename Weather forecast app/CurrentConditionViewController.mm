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

@property (weak) IBOutlet NSTextField *city;
@property (weak) IBOutlet NSTextField *country;
@property (weak) IBOutlet NSTextField *currentTemperature;
@property (weak) IBOutlet NSImageView *currentWeatherImage;

@end

@implementation CurrentConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _manager = Manager::getInstance();
    
    if(_manager->getModel()->getUserFavoriteCities().size() == 0)
    {
        _city.stringValue = @"";
        _country.stringValue = @"";
        _currentTemperature.stringValue = @"";
    }
    else
    {
        _city.stringValue = @(_manager->getModel()->getUserFavoriteCities()[_manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
        _country.stringValue = @(_manager->getModel()->getUserFavoriteCities()[_manager->getModel()->getNumberOfCurrentCity()]["country"].c_str());
        _currentTemperature.stringValue = [NSString stringWithFormat:@"Current temperature: %@ ℃",
                                           @(_manager->getModel()->getCurrentCondition()["temp_C"].c_str())];
    
        long weatherCode = [@(_manager->getModel()->getCurrentCondition()["weatherCode"].c_str()) integerValue];
    
        _currentWeatherImage.image = [NSImage imageNamed:[self weatherImageNameFromCode:weatherCode]];
    }
    
    __weak __typeof(self)weakSelf = self;
    
    _manager->getModel()->onUpdate.connect(CURRENT_CODITION_GROUP, [weakSelf](){
        weakSelf.city.stringValue = @(weakSelf.manager->getModel()->getUserFavoriteCities()[weakSelf.manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
        weakSelf.country.stringValue = @(weakSelf.manager->getModel()->getUserFavoriteCities()[weakSelf.manager->getModel()->getNumberOfCurrentCity()]["country"].c_str());
        weakSelf.currentTemperature.stringValue = [NSString stringWithFormat:@"Current temperature: %@ ℃",
                                           @(weakSelf.manager->getModel()->getCurrentCondition()["temp_C"].c_str())];
        
        long weatherCode = [@(weakSelf.manager->getModel()->getCurrentCondition()["weatherCode"].c_str()) integerValue];
        
        _currentWeatherImage.image = [NSImage imageNamed:[weakSelf weatherImageNameFromCode:weatherCode]];
        
    });
    
}

- (NSString*) weatherImageNameFromCode: (long) weatherCode
{
    // TODO: DELETE THIS
    switch (weatherCode) {
        case 113:
        {
            // Sunny
            return  @"113";
        }
        case 116:
        {
            // Partly Cloudy
            return @"116";
        }
        case 119:
        {
            // Cloudy
            return @"119";
        }
        case 122:
        {
            // Overcast
            return @"122";
        }
        case 143:
        case 248:
        case 260:
        {
            // Fog
            return @"143";
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
            return @"176";
        }
        case 200:
        case 395:
        case 392:
        case 389:
        case 386:
        {
            // Thunder
            return @"200";
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
            return @"302";
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
            return @"179";
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
            return @"227";
        }
        case 281:
        case 314:
        case 284:
        {
            // Freeze
            return @"281";
        }
        default:
        {
            return @"default";
        }
    }
}

@end
