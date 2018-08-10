//
//  CollectionsViewController.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//
//#include "Model.h"

#import "CollectionsViewController.h"

#import "HourWeatherItem.h"
#import "DailyWetherItem.h"
#import "ModelManager.h"

@interface CollectionsViewController ()

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) ModelManager *manager;
@property (weak) IBOutlet NSCollectionView *hourCollectionView;
@property (weak) IBOutlet NSCollectionView *daysCollectionView;

@end

@implementation CollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _manager = [ModelManager sharedManager];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    _hour = [components hour];
    
    
    __weak __typeof(self)weakSelf = self;
    
    _manager.model->onUpdate.connect(2, [weakSelf](){
        NSLog(@"I'm here!");
        [weakSelf.hourCollectionView reloadData];
        [weakSelf.daysCollectionView reloadData];
    });
    
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.manager.model->getUserFavoriteCities().size() > 0)
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
    if([[collectionView identifier] isEqualToString:@"hourForecast"])
    {
        
        int indexBasedOnTime = (indexPath.item+self.hour > 23)?(indexPath.item + self.hour-24) : (self.hour+indexPath.item);
        
        HourWeatherItem *item = [collectionView makeItemWithIdentifier:@"HourWeatherItem"
                                                          forIndexPath:indexPath ];
        
        item.time.stringValue = [NSString stringWithFormat:@"%d.00",indexBasedOnTime];
        item.temperature.stringValue = [NSString stringWithFormat:@"%@ ℃",
                                        @(_manager.model->getHoursForecast()[indexBasedOnTime]["tempC"].c_str())];
        item.weatherDesc.stringValue = @(_manager.model->getHoursForecast()[indexBasedOnTime]["weatherDesc"].c_str());
        
        long weatherCode = [@(_manager.model->getHoursForecast()[indexBasedOnTime]["weatherCode"].c_str()) integerValue];
        item.weatherImage.image = [NSImage imageNamed:[self weatherImageNameFromCode:weatherCode]];
        return item;
    }
    else
    {
        DailyWetherItem *item = [collectionView makeItemWithIdentifier:@"DailyWetherItem"
                                                          forIndexPath:indexPath ];
        item.date.stringValue = @(_manager.model->getDaysForecast()[(int)indexPath.item]["date"].c_str());
        item.temperature.stringValue = [NSString stringWithFormat:@"%@ ℃",
                                        @(_manager.model->getDaysForecast()[(int)indexPath.item]["tempC"].c_str())];
        long weatherCode = [@(_manager.model->getDaysForecast()[(int)indexPath.item]["weatherCode"].c_str()) integerValue];
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



@end
