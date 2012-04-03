//
//  BloodGPU.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Particles;

@interface BloodGPUParticle : NSObject
{
@public
	float time;
}

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc colorType:(int) colorType;
- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc;

- (bool)updateAndKeep:(float) time;
- (void)render;

@end
