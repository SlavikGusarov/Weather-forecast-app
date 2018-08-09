//
//  ModelManager.m
//  Weather forecast app
//
//  Created by air on 08.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager

@synthesize model;

#pragma mark Singleton Methods


+ (id)sharedManager {
    static ModelManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        //someProperty = @"Default Property Value";
        model = new Model();
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end