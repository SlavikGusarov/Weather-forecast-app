//
//  WindowController.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "Manager.h"

#import "WindowController.h"

@interface WindowController ()
{
    Manager *_manager;
}

@property (nonatomic, assign) Manager *manager;

@end

@implementation WindowController

@synthesize manager = _manager;

- (void)windowDidLoad {
    [super windowDidLoad];

    self.window.titleVisibility = NSWindowTitleHidden;
    
    _manager = Manager::getInstance();
    
    // If user has favorite cities, load weather forecast for first one
    if(_manager->getModel()->getUserFavoriteCities().size() != 0)
    {
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue
                       (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           weakSelf.manager->getModel()->getWeatherData
                           (weakSelf.manager->getModel()->getUserFavoriteCities()
                            [weakSelf.manager->getModel()->getNumberOfCurrentCity()]["name"]);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               weakSelf.manager->getModel()->onUpdate();
                           });
                       });
    }

}

@end
