//
//  WindowController.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.window.titleVisibility = NSWindowTitleHidden;
    
        dispatch_async(dispatch_get_global_queue
                       (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                                   
                           });
                       });
}

@end
