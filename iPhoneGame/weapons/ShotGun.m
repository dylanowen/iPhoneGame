//
//  ShotGun.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShotGun.h"

#import "Particles.h"

@implementation ShotGun

- (id)initWithParticles:(Particles *) part
{
	self = [super initWithParticles:part];
	if(self)
	{
		fireSpeed = 1.0f;
		return self;
	}
	return nil;
}

- (void)shootAtPosition:(GLKVector2) playerPosition direction:(GLKVector2) dir
{
	if(timeSinceShot > fireSpeed)
	{
		timeSinceShot = 0;
		GLKVector2 awayFromPlayer = GLKVector2Add(playerPosition, GLKVector2MultiplyScalar(dir, 7));
		GLKVector2 velocityUp = GLKVector2MultiplyScalar(dir, 200);
		GLKVector2 velocityDown = GLKVector2MultiplyScalar(dir, 200);
		GLKVector2 movementUp = GLKVector2MultiplyScalar(GLKVector2Normalize(GLKVector2Make(-velocityUp.y, velocityUp.x)), 10);
		GLKVector2 movementDown = GLKVector2MultiplyScalar(movementUp, -1);
		
		for(unsigned i = 0; i < 5; i++)
		{
			[particles addBulletWithPosition:awayFromPlayer velocity:velocityUp destructionRadius:10 damage:150];
			[particles addBulletWithPosition:awayFromPlayer velocity:velocityDown destructionRadius:10 damage:150];
			velocityUp = GLKVector2Add(velocityUp, movementUp);
			velocityDown = GLKVector2Add(velocityDown, movementDown);
		}
	}
}

@end
