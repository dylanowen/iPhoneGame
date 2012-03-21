//
//  Weapon.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"

#import "Particles.h"

@implementation Weapon

- (id)initWithParticles:(Particles *) part
{
	self = [super init];
	if(self)
	{
		particles = part;
		timeSinceShot = 0.0f;
		return self;
	}
	return nil;
}

- (void)update:(float) time
{
	timeSinceShot += time;
}

- (void)shootAtPosition:(GLKVector2) playerPosition direction:(GLKVector2) dir
{
	timeSinceShot = 0;
}

@end