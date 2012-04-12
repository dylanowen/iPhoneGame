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
@public
	NSString *name;
@protected
	
	float timeSinceShot;
	
	float fireSpeed;
	
	Particles *particles;
}

- (id)initWithParticles:(Particles *) part;

- (void)update;
- (void)shootAtPosition:(GLKVector2) position direction:(GLKVector2) dir;

@end
