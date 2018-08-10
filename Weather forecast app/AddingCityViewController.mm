//
//  AddingCityViewController.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//
#include <algorithm>
#include "Manager.h"

#import "AddingCityViewController.h"
#import "ModelManager.h"


@interface AddingCityViewController ()
{
    Manager *_manager;
}

@property (nonatomic, assign) Manager *manager;

@property (weak) IBOutlet NSTableView *table;

@end

@implementation AddingCityViewController

@synthesize manager = _manager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _manager = Manager::getInstance();
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue
                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       weakSelf.manager->getModel()->loadAllCities();
                       
//                       dispatch_async(dispatch_get_main_queue(), ^{
//                           
//                       });
                   });
    
}
- (IBAction)doneButton:(NSButton *)sender {
    if ([_table selectedRow] != -1)
    {
        self.manager->getModel()->setUserFavoriteCities(self.manager->getModel()->getCities()[[_table selectedRow]]);
        self.manager->getModel()->saveFavoriteCities();
    }
    
    [self dismissViewController:self];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue
                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       weakSelf .manager->getModel()->releaseListOfAllCities();
                    });
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewController:self];
}


- (IBAction)searchWith:(NSSearchField *)sender {
    if ([sender.stringValue length] == 0)
    {
        self.manager->getModel()->clearCities();
    }
    else
    {
        if([sender.stringValue length] > 2)
        {
            self.manager->getModel()->clearCities();
            long found = -1;
            std::string cityToLover;
            for(auto city : self.manager->getModel()->getAllCities())
            {
                cityToLover = city["name"];
                std::transform(cityToLover.begin(), cityToLover.end(), cityToLover.begin(), ::tolower);
                
                
                found = cityToLover.find([sender.stringValue.lowercaseString UTF8String]);
                if (found == 0)
                {
                    self.manager->getModel()->setCity(city);
                }
            }
        }
    }
    [_table reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)self.manager->getModel()->getCities().size();
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    return [NSString stringWithFormat:@"%@,%@ (Lat: %@; Lng: %@)", @(self.manager->getModel()->getCities()[row]["name"].c_str()),
                                                                   @(self.manager->getModel()->getCities()[row]["country"].c_str()),
                                                                   @(self.manager->getModel()->getCities()[row]["lat"].c_str()),
                                                                   @(self.manager->getModel()->getCities()[row]["lng"].c_str())];
}



@end
