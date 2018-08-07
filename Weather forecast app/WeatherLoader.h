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
//{
//    TemperatureScales _currentTemperatureFormat;
//}
//
//@property (nonatomic, assign) TemperatureScales currentTemperatureFormat;
//
//- (instancetype)init;
//
//- (void) setApiVersion:(NSString *) version;
//- (NSString *) apiVersion;
//
//- (void) setTemperatureFormat:(TemperatureScales) tempFormat;
//- (TemperatureScales) temperatureFormat;
//
//- (void) setLangWithPreferedLanguage;
//- (void) setLang:(NSString *) lang;
//- (NSString *) lang;
//
//#pragma mark - current weather
//
//-(void) currentWeatherByCityName:(NSString *) name
//                    withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//
//-(void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
//                      withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//-(void) currentWeatherByCityId:(NSString *) cityId
//                  withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//#pragma mark - forecast
//
//-(void) forecastWeatherByCityName:(NSString *) name
//                     withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//-(void) forecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
//                       withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//-(void) forecastWeatherByCityId:(NSString *) cityId
//                   withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//#pragma mark forcast - n days
//
//-(void) dailyForecastWeatherByCityName:(NSString *) name
//                             withCount:(int) count
//                           andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//-(void) dailyForecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
//                               withCount:(int) count
//                             andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//-(void) dailyForecastWeatherByCityId:(NSString *) cityId
//                           withCount:(int) count
//                         andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//#pragma mark search
//
//-(void) searchForCityName:(NSString *)name
//             withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//-(void) searchForCityName:(NSString *)name
//                withCount:(int) count
//              andCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
//
//@end