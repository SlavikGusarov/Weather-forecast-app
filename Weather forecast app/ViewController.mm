//
//  ViewController.m
//  Weather forecast app
//
//  Created by air on 03.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "Manager.h"


#import "ViewController.h"
#import "HourWeatherItem.h"
#import "DailyWetherItem.h"
#import "ModelManager.h"

#define MODEL_GROUP 1

@interface ViewController()
{
    Manager *_manager;
}


@property (weak) IBOutlet NSTextField *city;

//@property (nonatomic, assign) ModelManager *manager;

@property (nonatomic, assign) Manager *manager;

@end


@implementation ViewController

@synthesize manager = _manager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_manager = [ModelManager sharedManager];
    _manager = Manager::getInstance();
    
    //std::vector<std::map<std::string, std::string>> cities = _manager.model->getUserFavoriteCities();
    std::vector<std::map<std::string, std::string>> cities = _manager->getModel()->getUserFavoriteCities();
    
    if(cities.size() == 0)
    {
        _city.stringValue = @"";
    }
    else
    {
//        int currentCityNumber = _manager.model->getNumberOfCurrentCity();
//        _manager.model->getWeatherData(cities[currentCityNumber]["name"].append(",").append(cities[currentCityNumber]["country"]));
        
        int currentCityNumber = _manager->getModel()->getNumberOfCurrentCity();
        _manager->getModel()->getWeatherData(cities[currentCityNumber]["name"]);
        
        _city.stringValue = @(cities[currentCityNumber]["name"].c_str());
    }
    __weak __typeof(self)weakSelf = self;
    
//    _manager.model->onUpdate.connect(MODEL_GROUP, [weakSelf](){
//        weakSelf.city.stringValue = @(weakSelf.manager.model->getUserFavoriteCities()[weakSelf.manager.model->getNumberOfCurrentCity()]["name"].c_str());
//        weakSelf.country.stringValue = @(weakSelf.manager.model->getUserFavoriteCities()[weakSelf.manager.model->getNumberOfCurrentCity()]["country"].c_str());
//    });
    
    _manager->getModel()->onUpdate.connect(MODEL_GROUP, [weakSelf](){
        weakSelf.city.stringValue = @(weakSelf.manager->getModel()->getUserFavoriteCities()[weakSelf.manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
    });
    
//    dispatch_async(dispatch_get_global_queue
//                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//                   ^{
//    //                       dispatch_async(dispatch_get_main_queue(), ^{
//
//});
//                   });


}

- (IBAction)nextCityRight:(id)sender {
    self.manager->getModel()->nextCity();
}

- (IBAction)nextCityLeft:(id)sender {
    self.manager->getModel()->previousCity();
}

@end
