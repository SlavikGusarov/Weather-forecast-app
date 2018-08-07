//
//  HourWeatherItem.m
//  Weather forecast app
//
//  Created by air on 06.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import "HourWeatherItem.h"

@interface HourWeatherItem ()
@end

@implementation HourWeatherItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    //self.label.stringValue = @"123";
}


-(void)setRepresentedObject:(id)representedObject{
    [super setRepresentedObject:representedObject];
    if (representedObject !=nil)
    {
        NSLog(@"%@",[representedObject valueForKey:@"itemImage"]);
        
        //[self.label setStringValue:[representedObject valueForKey:@"label"]];
        
//        [self.titleTextField setStringValue:[representedObject valueForKey:@"itemTitle"]];
//        [self.descriptionTextField setStringValue:[representedObject valueForKey:@"itemDescription"]];
//        [self.detailDescription setStringValue:[representedObject valueForKey:@"itemDetailedDescription"]];
//        [self.price setStringValue:[representedObject valueForKey:@"itemPrice"]];
//        [self.itemImageView setImage:[[NSBundle mainBundle] imageForResource:[representedObject valueForKey:@"itemImage"]]];
        
    }
    else
    {
        //[self.label setStringValue:@"No Value"];
        
        //_label.stringValue = @"123";
//        [self.titleTextField setStringValue:@"No Value"];
//        [self.descriptionTextField setStringValue:@"No Value"];
//        [self.detailDescription setStringValue:@"No Value"];
//        [self.price setStringValue:@"No Value"];
        
    }
}

@end
