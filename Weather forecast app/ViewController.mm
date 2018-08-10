//
//  ViewController.m
//  Weather forecast app
//
//  Created by air on 03.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "Manager.h"


#import "ViewController.h"


#define MODEL_GROUP 1

@interface ViewController()
{
    Manager *_manager;
}

@property (weak) IBOutlet NSTextField *city;

@property (nonatomic, assign) Manager *manager;

@end


@implementation ViewController

@synthesize manager = _manager;

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = Manager::getInstance();
    
    std::vector<std::map<std::string, std::string>> cities = _manager->getModel()->getUserFavoriteCities();
    
    // If user has not favorite cities, clean lable
    if(cities.size() == 0)
    {
        _city.stringValue = @"";
    }
    // If user has favorite cities, load title for first one
    else
    {
        _city.stringValue = @(cities[_manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
    }
    
    __weak __typeof(self)weakSelf = self;
    // Subscribe to data update
    _manager->getModel()->onUpdate.connect(MODEL_GROUP, [weakSelf](){
        weakSelf.city.stringValue = @(weakSelf.manager->getModel()->getUserFavoriteCities()[weakSelf.manager->getModel()->getNumberOfCurrentCity()]["name"].c_str());
        
    });


}

#pragma mark - Buttons

- (IBAction)nextCityRight:(id)sender {
    self.manager->getModel()->nextCity();
}

- (IBAction)nextCityLeft:(id)sender {
    self.manager->getModel()->previousCity();
}

@end
