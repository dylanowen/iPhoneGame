//
//  Sniper.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sniper.h"

#import "Particles.h"

@implementation Sniper

- (id)initWithParticles:(Particles *) part
{
	self = [super initWithParticles:part];
	if(self)
	{
		name = @"Sniper";
		fireSpeed = 1.0f;
		return self;
	}
	return nil;
}

- (void)shootAtPosition:(GLKVector2) playerPosition direction:(GLKVector2) dir startVelocity:(GLKVector2) vel
{
	if(timeSinceShot > fireSpeed)
	{
		timeSinceShot = 0;
		GLKVector2 awayFromPlayer = GLKVector2Add(playerPosition, GLKVector2MultiplyScalar(dir, 7));
		[particles addBulletWithPosition: awayFromPlayer velocity:GLKVector2MultiplyScalar(dir, 350) destructionRadius:15 damage:1000];
	}
}

@end
