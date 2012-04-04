//
//  HealingParticle.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "Particle.h"

@class Particles;

@interface HealingParticle : NSObject <Particle>

- (id)initWithParticles:(Particles *) particles position:(GLKVector2) posit;

@end
