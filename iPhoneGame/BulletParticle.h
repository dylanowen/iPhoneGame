//
//  BulletParticle.h
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Bullets;

@interface BulletParticle : NSObject

- (id)initWithBulletsModel:(Bullets *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius;

- (bool)updateAndKeep:(float) time;
- (void)render;

@end
