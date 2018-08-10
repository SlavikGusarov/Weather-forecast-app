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

#pragma mark - interface

@interface AddingCityViewController ()
{
    Manager *_manager;
}

@property (nonatomic, assign) Manager *manager;

@property (weak) IBOutlet NSTableView *table;

@property (nonatomic, assign) BOOL isSearching;

@end

@implementation AddingCityViewController

@synthesize manager = _manager;

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = Manager::getInstance();
    _isSearching = NO;
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue
                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       weakSelf.manager->getModel()->loadAllCities();
                   });
    
}

#pragma mark - Done and cancel byttons

- (IBAction)doneButton:(NSButton *)sender {
    if ([_table selectedRow] != -1)
    {
        bool alreadyExist = false;
        for(auto city : self.manager->getModel()->getUserFavoriteCities())
        {
            if(city["lat"] == self.manager->getModel()->getCities()[[_table selectedRow]]["lat"] &&
               city["lng"] == self.manager->getModel()->getCities()[[_table selectedRow]]["lng"])
            {
                alreadyExist = true;
            }
        }
        if (!alreadyExist)
        {
            self.manager->getModel()->setUserFavoriteCities(self.manager->getModel()->getCities()[[_table selectedRow]]);
            self.manager->getModel()->saveFavoriteCities();
        }
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue
                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       weakSelf.manager->getModel()->releaseListOfAllCities();
                   });
    [self dismissViewController:self];
}

- (IBAction)cancelButton:(id)sender {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue
                   (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       weakSelf.manager->getModel()->releaseListOfAllCities();

                   });
    [self dismissViewController:self];
}

#pragma mark - Search

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
            if(!self.isSearching)
            {
                __weak __typeof(self)weakSelf = self;
                dispatch_async(dispatch_get_global_queue
                               (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                               ^{
                                   long found = -1;
                                   std::string cityToLover;
                                   for(auto city : weakSelf.manager->getModel()->getAllCities())
                                   {
                                       cityToLover = city["name"];
                                       std::transform(cityToLover.begin(), cityToLover.end(), cityToLover.begin(), ::tolower);
                                       
                                       found = cityToLover.find([sender.stringValue.lowercaseString UTF8String]);
                                       if (found == 0)
                                       {
                                           weakSelf.manager->getModel()->setCity(city);
                                       }
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       weakSelf.isSearching = NO;
                                       [weakSelf.table reloadData];
                                   });
                                });
            }
        }
    }
    [self.table reloadData];
}

#pragma mark - NSTableViewDataSource functions

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
