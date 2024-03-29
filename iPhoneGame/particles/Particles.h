//
//  Particles.h
//  iPhoneGame
//
//  Created by Lion User on 02/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "BloodParticle.h"

@class GameModel;

@interface Particles : NSObject
{
@public
	GameModel *game;
	
	GLuint bulletPositionAttribute;
	GLuint bloodPositionAttribute;
	GLuint bloodColorAttribute;
	
	GLuint healthParticleInitialPosition;
	GLuint healthParticleTime;
}

- (id)initWithModel:(GameModel *) model;

- (void)addBulletWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;
- (void)addBulletGravWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;
- (void)addBulletBouncyWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;
- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power;
- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType count:(int) count;
- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType;
- (void)addHealingEffect:(GLKVector2) posit;
- (void)update;
- (void)render;

@end
