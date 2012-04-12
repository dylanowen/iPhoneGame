//
//  Pickups.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pickups.h"

#import "ZombieSkull.h"

@interface Pickups()
{
	NSMutableArray *items;
}
@end

@implementation Pickups

- (id)init
{
	self = [super init];
	if(self)
	{
		items = [[NSMutableArray alloc] init];
		
		return self;
	}
	return nil;
}

- (void)addZombieSkullWithPosition:(GLKVector2) posit
{
	[items addObject:[[ZombieSkull alloc] initWithPosition:posit]];
}

- (void)addHealthWithPosition:(GLKVector2) posit
{
	//[items addObject:[[Item alloc] initWithPosition:posit]];
}

- (void)update
{
	//remove bullets that say they're done
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [items count]; i++)
	{
		if(![[items objectAtIndex: i] updateAndKeep])
		{
			[indexes addIndex: i];
		}
	}
	[items removeObjectsAtIndexes: indexes];
}

- (void)render
{
	[items makeObjectsPerformSelector:@selector(render)];
}

@end
