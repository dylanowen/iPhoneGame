//
//  ZombieCharacter.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

- (bool)update:(float) time projection:(GLKMatrix4) matrix
{
	[self update: time];
	projection = matrix;
	return health > 0;
}

@end
