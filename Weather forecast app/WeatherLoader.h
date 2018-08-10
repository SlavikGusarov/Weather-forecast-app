//
//  WeatherLoader.h
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface WeatherLoader : NSObject

- (NSDictionary*) getWeatherForDays:(int)days andCity:(NSString*)city withTimeInterval:(int)time;

@end
