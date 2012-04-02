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

+ (id)sharedManager
{
	@synchronized(self)
	{
		if(gameSettings == nil)
		{
			gameSettings = [[self alloc] init];
		}
	}
	return gameSettings;
}

- (id)init
{
	self = [super init];
	if(self)
	{
		self.weapon = 2;
		return self;
	}
	return nil;
}


@end
