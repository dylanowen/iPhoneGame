//
//  EffectLoader.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectLoader.h"

@interface EffectLoader()
{
	NSMutableDictionary *effects;
}

@end

@implementation EffectLoader

- (id)init
{
	self = [super init];
	if(self)
	{
		effects = [[NSMutableDictionary alloc] init];
		
		return self;
	}
	return nil;
}

- (GLKBaseEffect *)addEffectForName:(NSString *) name
{
	GLKBaseEffect *temp = [effects objectForKey:name];
	if(temp == nil)
	{
		temp = [[GLKBaseEffect alloc] init];
		[effects setObject:temp forKey:name];
		//NSLog(@"Generated effect: %@", name);
	}
	return temp;
}

- (GLKBaseEffect *)getEffectForName:(NSString *) name
{
	return [effects objectForKey:name];
}

@end
