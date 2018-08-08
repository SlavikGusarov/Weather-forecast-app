//
//  ViewController.m
//  Weather forecast app
//
//  Created by air on 03.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "Manager.h"
#include "Model.h"

#import "ViewController.h"
#import "HourWeatherItem.h"
#import "DailyWetherItem.h"

@interface ViewController()
{
    Model *model;
    //Manager manager;
}
@property (weak) IBOutlet NSTextField *city;
@property (weak) IBOutlet NSTextField *country;
@property (weak) IBOutlet NSTextField *currentTemperature;
@property (weak) IBOutlet NSImageView *currentWeatherImage;

@property (nonatomic, assign) NSInteger hour;
@end


@implementation ViewController
- (IBAction)move:(NSButton *)sender {
    [self performSegueWithIdentifier:@"segue1" sender:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = new Model();
    
    model->getWeatherData("Odessa,ua");
    
//    dispatch_async(dispatch_get_global_queue
//                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//                   ^{
//
//                   });
    _city.stringValue = @"Odessa";
    _country.stringValue = @"Ukraine";
    _currentTemperature.stringValue = [NSString stringWithFormat:@"Current temperature: %@ ℃", @(model->getCurrentCondition()["temp_C"].c_str())];
    
    
    long weatherCode = [@(model->getCurrentCondition()["weatherCode"].c_str()) integerValue];
    
    _currentWeatherImage.image = [NSImage imageNamed:[self weatherImageNameFromCode:weatherCode]];
    
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    _hour = [components hour];
    //NSInteger minute = [components minute];
    
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
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

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    if([[collectionView identifier] isEqualToString:@"hourForecast"])
    {
        
        int indexBasedOnTime = (indexPath.item+self.hour > 23)?(indexPath.item + self.hour-24) : (self.hour+indexPath.item);
        
        HourWeatherItem *item = [collectionView makeItemWithIdentifier:@"HourWeatherItem"
                                                          forIndexPath:indexPath ];
        
        item.time.stringValue = [NSString stringWithFormat:@"%d.00",indexBasedOnTime];
        item.temperature.stringValue = [NSString stringWithFormat:@"%@ ℃",
                                        @(model->getHoursForecast()[indexBasedOnTime]["tempC"].c_str())];
        item.weatherDesc.stringValue = @(model->getHoursForecast()[indexBasedOnTime]["weatherDesc"].c_str());
        
        long weatherCode = [@(model->getHoursForecast()[indexBasedOnTime]["weatherCode"].c_str()) integerValue];
        item.weatherImage.image = [NSImage imageNamed:[self weatherImageNameFromCode:weatherCode]];
        return item;
    }
    else
    {
        DailyWetherItem *item = [collectionView makeItemWithIdentifier:@"DailyWetherItem"
                                                          forIndexPath:indexPath ];
        item.date.stringValue = @(model->getDaysForecast()[(int)indexPath.item]["date"].c_str());
        item.temperature.stringValue = [NSString stringWithFormat:@"%@ ℃",
                                        @(model->getDaysForecast()[(int)indexPath.item]["tempC"].c_str())];
        long weatherCode = [@(model->getDaysForecast()[(int)indexPath.item]["weatherCode"].c_str()) integerValue];
        item.weatherImage.image = [NSImage imageNamed:[self weatherImageNameFromCode:weatherCode]];
        
        return item;
    }

}

- (NSString*) weatherImageNameFromCode: (long) weatherCode
{
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

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
