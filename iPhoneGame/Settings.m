//
//  Settings.m
//  iPhoneGame
//
//  Created by Rucha Heda on 3/20/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "Settings.h"

static Settings* gameSettings = nil;

@implementation Settings
@synthesize weapon;

+ (id) sharedManager {
    @synchronized(self) {
        if (gameSettings == nil) {
            gameSettings = [[self alloc] init];
        }
    }
    return gameSettings;
}

- (id) init {
    if (self = [super init]) {
        gameSettings.weapon = 0;
    }
    return self;
}


@end
