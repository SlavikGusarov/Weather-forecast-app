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
    NSString *_city;// = @"&q=48.85,2.35";
    NSString *_numberOfDays;// = @"&num_of_days=2";
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
    
    /// TODO: Error handler
    if([responseCode statusCode] != 200)
    {
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        NSLog(@"%@", error);
    }
    
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:oResponseData
                                                         options:0
                                                           error:&error];
    NSLog(@"%@", result);
    return [result objectForKey:@"data"];
}



@end
//@synthesize currentTemperatureFormat = _currentTemperatureFormat;
//
//#pragma mark - Init
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _baseURL = @"http://api.openweathermap.org/data/";
//        _apiKey  = @"dd30619065dae79fd33f318455d18961";
//        _apiVersion = @"2.5";
//        _currentTemperatureFormat = temperatureCelcius;
//    }
//    return self;
//}
//
////- (void) setTemperatureFormat:(TemperatureScales) tempFormat {
////    _currentTemperatureFormat = tempFormat;
////}
////- (TemperatureScales) temperatureFormat {
////    return _currentTemperatureFormat;
////}
//
//#pragma mark - Temperature convertation
//
//+ (NSNumber *) tempToCelcius:(NSNumber *) tempKelvin
//{
//    return @(tempKelvin.floatValue - 273.15);
//}
//
//+ (NSNumber *) tempToFahrenheit:(NSNumber *) tempKelvin
//{
//    return @((tempKelvin.floatValue * 9/5) - 459.67);
//}
//
//
//- (NSNumber *) convertTemp:(NSNumber *) temp {
//    if (_currentTemperatureFormat == temperatureCelcius) {
//        return [WeatherLoader tempToCelcius:temp];
//    } else if (_currentTemperatureFormat == temperatureFahrenheit) {
//        return [WeatherLoader tempToFahrenheit:temp];
//    } else {
//        return temp;
//    }
//}
//
//#pragma mark - Date convertation
//
//- (NSDate *) convertToDate:(NSNumber *) num {
//    return [NSDate dateWithTimeIntervalSince1970:num.intValue];
//}
//
///**
// * Recursivly change temperatures in result data
// **/
//
//#pragma mark - Forecast convertation
//
//// Рекурсивно меняет формат температуры, на заданую пользователем
//// Приводит дату в формат NSDate
//- (NSDictionary *) convertResult:(NSDictionary *) res {
//    
//    NSMutableDictionary *dic = [res mutableCopy];
//    
//    NSMutableDictionary *main = [[dic objectForKey:@"main"] mutableCopy];
//    if (main) {
//        main[@"temp"] = [self convertTemp:main[@"temp"]];
//        main[@"temp_min"] = [self convertTemp:main[@"temp_min"]];
//        main[@"temp_max"] = [self convertTemp:main[@"temp_max"]];
//        
//        dic[@"main"] = [main copy];
//        
//    }
//    
//    NSMutableDictionary *temp = [[dic objectForKey:@"temp"] mutableCopy];
//    if (temp) {
//        temp[@"day"] = [self convertTemp:temp[@"day"]];
//        temp[@"eve"] = [self convertTemp:temp[@"eve"]];
//        temp[@"max"] = [self convertTemp:temp[@"max"]];
//        temp[@"min"] = [self convertTemp:temp[@"min"]];
//        temp[@"morn"] = [self convertTemp:temp[@"morn"]];
//        temp[@"night"] = [self convertTemp:temp[@"night"]];
//        
//        dic[@"temp"] = [temp copy];
//    }
//    
//    
//    NSMutableDictionary *sys = [[dic objectForKey:@"sys"] mutableCopy];
//    if (sys) {
//        
//        sys[@"sunrise"] = [self convertToDate: sys[@"sunrise"]];
//        sys[@"sunset"] = [self convertToDate: sys[@"sunset"]];
//        
//        dic[@"sys"] = [sys copy];
//    }
//    
//    
//    NSMutableArray *list = [[dic objectForKey:@"list"] mutableCopy];
//    if (list) {
//        
//        for (int i = 0; i < list.count; i++) {
//            [list replaceObjectAtIndex:i withObject:[self convertResult: list[i]]];
//        }
//        
//        dic[@"list"] = [list copy];
//    }
//    
//    dic[@"dt"] = [self convertToDate:dic[@"dt"]];
//    
//    return [dic copy];
//}
//
//
//
///**
// * Calls the web api, and converts the result. Then it calls the callback on the caller-queue
// **/
//- (void) callMethod:(NSString *) method withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    // build the lang paramter
//    NSString *langString;
//    if (_lang && _lang.length > 0) {
//        langString = [NSString stringWithFormat:@"&lang=%@", _lang];
//    } else {
//        langString = @"";
//    }
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@%@&APPID=%@%@", _baseURL, _apiVersion, method, _apiKey, langString];
//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//}
//
//#pragma mark - public api
//
//- (void) setApiVersion:(NSString *) version {
//    _apiVersion = version;
//}
//
//- (NSString *) apiVersion {
//    return _apiVersion;
//}
//
//- (void) setLangWithPreferedLanguage {
//    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
//    
//    // look up, lang and convert it to the format that openweathermap.org accepts.
//    NSDictionary *langCodes = @{
//                                @"sv" : @"se",
//                                @"es" : @"sp",
//                                @"en-GB": @"en",
//                                @"uk" : @"ua",
//                                @"pt-PT" : @"pt",
//                                @"zh-Hans" : @"zh_cn",
//                                @"zh-Hant" : @"zh_tw",
//                                };
//    
//    NSString *l = [langCodes objectForKey:lang];
//    if (l) {
//        lang = l;
//    }
//    
//    
//    [self setLang:lang];
//}
//
//- (void) setLang:(NSString *) lang {
//    _lang = lang;
//}
//
//- (NSString *) lang {
//    return _lang;
//}
//
//#pragma mark current weather
//
//-(void) currentWeatherByCityName:(NSString *) name
//                    withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    
//    NSString *method = [NSString stringWithFormat:@"/weather?q=%@", name];
//    [self callMethod:method withCallback:callback];
//    
//}
//
//-(void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
//                      withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    
//    NSString *method = [NSString stringWithFormat:@"/weather?lat=%f&lon=%f",
//                        coordinate.latitude, coordinate.longitude ];
//    [self callMethod:method withCallback:callback];
//    
//}
//
//-(void) currentWeatherByCityId:(NSString *) cityId
//                  withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    NSString *method = [NSString stringWithFormat:@"/weather?id=%@", cityId];
//    [self callMethod:method withCallback:callback];
//}
//
//
//#pragma mark forcast
//
//-(void) forecastWeatherByCityName:(NSString *) name
//                     withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    
//    NSString *method = [NSString stringWithFormat:@"/forecast?q=%@", name];
//    [self callMethod:method withCallback:callback];
//    
//}
//
//-(void) forecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
//                       withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    
//    NSString *method = [NSString stringWithFormat:@"/forecast?lat=%f&lon=%f",
//                        coordinate.latitude, coordinate.longitude ];
//    [self callMethod:method withCallback:callback];
//    
//}
//
//-(void) forecastWeatherByCityId:(NSString *) cityId
//                   withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    NSString *method = [NSString stringWithFormat:@"/forecast?id=%@", cityId];
//    [self callMethod:method withCallback:callback];
//}
//
//#pragma mark forcast - n days
//
//-(void) dailyForecastWeatherByCityName:(NSString *) name
//                             withCount:(int) count
//                           andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    
//    NSString *method = [NSString stringWithFormat:@"/forecast/daily?q=%@&cnt=%d", name, count];
//    [self callMethod:method withCallback:callback];
//    
//}
//
//-(void) dailyForecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
//                               withCount:(int) count
//                             andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    
//    NSString *method = [NSString stringWithFormat:@"/forecast/daily?lat=%f&lon=%f&cnt=%d",
//                        coordinate.latitude, coordinate.longitude, count ];
//    [self callMethod:method withCallback:callback];
//    
//}
//
//-(void) dailyForecastWeatherByCityId:(NSString *) cityId
//                           withCount:(int) count
//                         andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    NSString *method = [NSString stringWithFormat:@"/forecast/daily?id=%@&cnt=%d", cityId, count];
//    [self callMethod:method withCallback:callback];
//}
//
//
//#pragma mark searching
//
//-(void) searchForCityName:(NSString *)name
//             withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    NSString *method = [NSString stringWithFormat:@"/find?q=%@&units=metric", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [self callMethod:method withCallback:callback];
//}
//
//-(void) searchForCityName:(NSString *)name
//                withCount:(int) count
//              andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
//{
//    NSString *method = [NSString stringWithFormat:@"/find?q=%@&units=metric&cnt=%d", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], count];
//    [self callMethod:method withCallback:callback];
//}
//


//@end