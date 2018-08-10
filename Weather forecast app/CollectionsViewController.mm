//
//  CollectionsViewController.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//
#include "Manager.h"

#import "CollectionsViewController.h"
#import "WeatherItem.h"


#define COLLECTION_CONTROLLER_GROUP 2

@interface CollectionsViewController ()
{
    Manager *_manager;
}

@property (nonatomic, assign) Manager *manager;
@property (nonatomic, assign) NSInteger hour;

@property (weak) IBOutlet NSCollectionView *hourCollectionView;
@property (weak) IBOutlet NSCollectionView *daysCollectionView;

@end

@implementation CollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _manager = Manager::getInstance();
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    _hour = [components hour];
    
    
    __weak __typeof(self)weakSelf = self;
    
    _manager->getModel()->onUpdate.connect(COLLECTION_CONTROLLER_GROUP, [weakSelf](){
        [weakSelf.hourCollectionView reloadData];
        [weakSelf.daysCollectionView reloadData];
    });
    
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.manager->getModel()->getUserFavoriteCities().size() > 0)
    {
        if([[collectionView identifier] isEqualToString:@"hourForecast"])
        {
            return 24;
        }
        else
        {
            return 14;
        }
    }
    else
    {
        return 0;
    }
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    
    long indexBasedOnTime = indexPath.item;
    WeatherItem *item = [collectionView makeItemWithIdentifier:@"WeatherItem"
                                                      forIndexPath:indexPath ];
    std::vector<std::map<std::string, std::string>> forecast;
    if([[collectionView identifier] isEqualToString:@"hourForecast"])
    {
        indexBasedOnTime = (indexPath.item+self.hour > 23)?(indexPath.item + self.hour-24) : (self.hour+indexPath.item);
        forecast = self.manager->getModel()->getHoursForecast();
        long weatherCode = [@(forecast[indexBasedOnTime]["weatherCode"].c_str()) integerValue];
        item.weatherImage.image = [NSImage imageNamed:@(self.manager->getModel()->weatherImageNameFromCode(weatherCode, indexBasedOnTime).c_str())];
        item.time.stringValue = [NSString stringWithFormat:@"%li.00",indexBasedOnTime];
    }
    else
    {
        forecast = self.manager->getModel()->getDaysForecast();
        long weatherCode = [@(forecast[(int)indexPath.item]["weatherCode"].c_str()) integerValue];
        item.weatherImage.image = [NSImage imageNamed:@(self.manager->getModel()->weatherImageNameFromCode(weatherCode,12).c_str())];
        item.time.stringValue = @(forecast[(int)indexPath.item]["date"].c_str());
    }
        
    
    item.temperature.stringValue = [NSString stringWithFormat:@"Temp: %@ ℃",
                                    @(forecast[indexBasedOnTime]["tempC"].c_str())];
    item.weatherDesc.stringValue = [NSString stringWithFormat:@"Desc: %@ ℃",
                                    @(forecast[indexBasedOnTime]["weatherDesc"].c_str())];
    item.windSpeed.stringValue = [NSString stringWithFormat:@"Wind speed: %@ Kmph",
                                 @(forecast[indexBasedOnTime]["windspeedKmph"].c_str())];
    item.precipMM.stringValue = [NSString stringWithFormat:@"Precipitation: %@ mm",
                                 @(forecast[indexBasedOnTime]["precipMM"].c_str())];
    item.humidity.stringValue = [NSString stringWithFormat:@"Humidity : %@ %%",
                                 @(forecast[indexBasedOnTime]["humidity"].c_str())];
    item.visibility.stringValue = [NSString stringWithFormat:@"Visibility : %@ Km",
                                   @(forecast[indexBasedOnTime]["visibility"].c_str())];
    item.pressure.stringValue = [NSString stringWithFormat:@"Pressure: %@ mb",
                                 @(forecast[indexBasedOnTime]["pressure"].c_str())];
    item.cloudcover.stringValue = [NSString stringWithFormat:@"Cloud cover: %@ %%",
                                   @(forecast[indexBasedOnTime]["cloudcover"].c_str())];
    item.chanceOfRain.stringValue = [NSString stringWithFormat:@"Chance of rain: %@ %%",
                                     @(forecast[indexBasedOnTime]["chanceofrain"].c_str())];
    

    return item;
//    }
//    else
//    {
//        DailyWetherItem *item = [collectionView makeItemWithIdentifier:@"DailyWetherItem"
//                                                          forIndexPath:indexPath ];
//        item.date.stringValue = @(self.manager->getModel()->getDaysForecast()[(int)indexPath.item]["date"].c_str());
//        item.temperature.stringValue = [NSString stringWithFormat:@"%@ ℃",
//                                        @(self.manager->getModel()->getDaysForecast()[(int)indexPath.item]["tempC"].c_str())];
//        long weatherCode = [@(self.manager->getModel()->getDaysForecast()[(int)indexPath.item]["weatherCode"].c_str()) integerValue];
//        item.weatherImage.image = [NSImage imageNamed:@(self.manager->getModel()->weatherImageNameFromCode(weatherCode,12).c_str())];
//        
//        return item;
//    }
    
}
@end
