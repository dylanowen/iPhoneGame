//
//  MachineGun.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MachineGun.h"

#import "Particles.h"

@implementation MachineGun

- (id)initWithParticles:(Particles *) part
{
	self = [super initWithParticles:part];
	if(self)
	{
		name = @"Machine Gun";
		fireSpeed = 0.05;
		return self;
	}
	return nil;
}

- (void)shootAtPosition:(GLKVector2) playerPosition direction:(GLKVector2) dir startVelocity:(GLKVector2) vel
{
	if(timeSinceShot > fireSpeed)
	{
		timeSinceShot = 0;
		GLKVector2 awayFromPlayer = GLKVector2Add(playerPosition, GLKVector2MultiplyScalar(dir, 10));
		[particles addBulletWithPosition: awayFromPlayer velocity:GLKVector2Add(GLKVector2MultiplyScalar(dir, 150), vel) destructionRadius:10 damage:80];
	}
}

@end
