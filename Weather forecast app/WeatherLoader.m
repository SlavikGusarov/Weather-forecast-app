//
//  WeatherLoader.m
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import "WeatherLoader.h"

@interface WeatherLoader()
{
    NSString *_baseURL;
    NSString *_key;
    NSString *_city;
    NSString *_numberOfDays;
    NSString *_timeInterval;
    NSString *_format;
    NSString *_fx24;
    NSString* _monthlyClimateAverage;
}

@end


@implementation WeatherLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        _baseURL = @"https://api.worldweatheronline.com/premium/v1/weather.ashx?";
        _key = @"key=657306ab29024e0489c131520180408";
        _timeInterval = @"&tp=1";
        _format = @"&format=json";
        _fx24 = @"&fx24=yes";
        _monthlyClimateAverage = @"&mca=no";
    }
    return self;
}

- (NSDictionary*) getWeatherForDays:(int)days andCity:(NSString*)city withTimeInterval:(int)time
{
    _city = [[NSString alloc] initWithFormat:@"&q=%@", city];
    _numberOfDays = [[NSString alloc] initWithFormat:@"&num_of_days=%i", days];
    _timeInterval = [[NSString alloc] initWithFormat:@"&tp=%i", time];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    NSURL* url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                   _baseURL,
                   _key,
                   _city,
                   _numberOfDays,
                   _timeInterval,
                   _fx24,
                   _monthlyClimateAverage,
                   _format]];
    
    [request setURL:url];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&responseCode
                                                              error:&error];
    
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        NSLog(@"%@", error);
        return nil;
    }
    
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:oResponseData
                                                         options:0
                                                           error:&error];
    if(result == nil || error)
    {
         NSLog(@"%@", error);
        return nil;
    }
    
    if([[result objectForKey:@"data"] objectForKey:@"error"])
    {
        NSLog(@"Error, https://developer.worldweatheronline.com/ : %@", [[[[result objectForKey:@"data"]
                               objectForKey:@"error"]
                               objectAtIndex:0]
                               objectForKey:@"msg"]);
    }
    
    return [result objectForKey:@"data"];
}



@end