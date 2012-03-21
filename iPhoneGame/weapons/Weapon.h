//
//  Weapon.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Particles;

@interface Weapon : NSObject
{
	float timeSinceShot;
	
	float fireSpeed;
	
	Particles *particles;
}

- (id)initWithParticles:(Particles *) part;

- (void)update:(float) time;
- (void)shootAtPosition:(GLKVector2) position direction:(GLKVector2) dir;

@end
