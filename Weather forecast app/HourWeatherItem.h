//
//  HourWeatherItem.h
//  Weather forecast app
//
//  Created by air on 06.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HourWeatherItem : NSCollectionViewItem
@property (weak) IBOutlet NSTextField *time;
@property (weak) IBOutlet NSTextField *temperature;
@property (weak) IBOutlet NSTextField *weatherDesc;
@property (weak) IBOutlet NSImageCell *weatherImage;
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
@property (weak) IBOutlet NSTextField *chanceOfRain;
@end
