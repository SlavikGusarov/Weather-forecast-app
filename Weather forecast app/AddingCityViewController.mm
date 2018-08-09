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
        NSLog(@"%@", sender.stringValue);
        if([sender.stringValue length] > 2)
        {
            _manager.model->clearCities();
            int found = -1;
            std::string cityToLover;
            for(auto city : _manager.model->getAllCities())
            {
                std::string data = "Abc";
                std::transform(data.begin(), data.end(), data.begin(), ::tolower);
                
                cityToLover = city["name"];
                std::transform(cityToLover.begin(), cityToLover.end(), cityToLover.begin(), ::tolower);
                
                
                found = cityToLover.find([sender.stringValue.lowercaseString UTF8String]);
                if (found == -1)
                {
                    continue;
                }
                else if (found == 0)
                {
                    _manager.model->setCity(city);
                }
            }
        }
        [_table reloadData];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    //NSLog(@"%ld", (long)_manager.model->getAllCities().size());
    return (NSInteger)_manager.model->getCities().size();
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
    NSLog(@"%@", @(_manager.model->getCities()[row]["name"].c_str()));

    return [NSString stringWithFormat:@"%@,%@ (Lat: %@; Lng: %@)", @(_manager.model->getCities()[row]["name"].c_str()),
                                                                   @(_manager.model->getCities()[row]["country"].c_str()),
                                                                   @(_manager.model->getCities()[row]["lat"].c_str()),
                                                                   @(_manager.model->getCities()[row]["lng"].c_str())];
}

@end
