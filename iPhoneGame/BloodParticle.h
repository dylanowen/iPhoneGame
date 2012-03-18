//
//  BloodParticle.h
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

enum
{
	BloodColorRed = 0,
	BloodColorGreen = 1,
	BloodColorBlue = 2,
	BloodColorWhite = 3,
	BloodColorBlack = 4
};

@class Particles;

@interface BloodParticle : NSObject

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc colorType:(int) colorType;
- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc;

- (bool)updateAndKeep:(float) time;
- (void)render;

@end
