//
//  AddingCityViewController.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//
#include <algorithm>

#import "AddingCityViewController.h"
#import "ModelManager.h"


@interface AddingCityViewController ()

@property (nonatomic, assign) ModelManager *manager;

@property (weak) IBOutlet NSTableView *table;

@end

@implementation AddingCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _manager = [ModelManager sharedManager];
}
- (IBAction)doneButton:(NSButton *)sender {
    if ([_table selectedRow] != -1)
    {
        _manager.model->setUserFavoriteCities(_manager.model->getCities()[[_table selectedRow]]);
        _manager.model->saveFavoriteCities();
        //_manager.model->onUpdate("");
    }
    
    [self dismissViewController:self];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewController:self];
}


- (IBAction)searchWith:(NSSearchField *)sender {
    if ([sender.stringValue length] == 0)
    {
        NSLog(@"Empty!");
        _manager.model->clearCities();
    }
    else
    {
        if([sender.stringValue length] > 2)
        {
            _manager.model->clearCities();
            long found = -1;
            std::string cityToLover;
            for(auto city : _manager.model->getAllCities())
            {
                cityToLover = city["name"];
                std::transform(cityToLover.begin(), cityToLover.end(), cityToLover.begin(), ::tolower);
                
                
                found = cityToLover.find([sender.stringValue.lowercaseString UTF8String]);
                if (found == 0)
                {
                    _manager.model->setCity(city);
                }
            }
        }
    }
    [_table reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return (NSInteger)_manager.model->getCities().size();
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    return [NSString stringWithFormat:@"%@,%@ (Lat: %@; Lng: %@)", @(_manager.model->getCities()[row]["name"].c_str()),
                                                                   @(_manager.model->getCities()[row]["country"].c_str()),
                                                                   @(_manager.model->getCities()[row]["lat"].c_str()),
                                                                   @(_manager.model->getCities()[row]["lng"].c_str())];
}



@end
