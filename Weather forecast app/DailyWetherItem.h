//
//  DailyWetherItem.h
//  Weather forecast app
//
//  Created by air on 07.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DailyWetherItem : NSCollectionViewItem
@property (weak) IBOutlet NSTextField *date;
@property (weak) IBOutlet NSImageView *weatherImage;
@property (weak) IBOutlet NSTextField *temperature;

@end
