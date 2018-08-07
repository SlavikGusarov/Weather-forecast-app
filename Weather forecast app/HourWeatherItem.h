//
//  HourWeatherItem.h
//  Weather forecast app
//
//  Created by air on 06.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HourWeatherItem : NSCollectionViewItem
@property (weak) IBOutlet NSTextFieldCell *label;
@property (weak) IBOutlet NSImageCell *image;
@end
