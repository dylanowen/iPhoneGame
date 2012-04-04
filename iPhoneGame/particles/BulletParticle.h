//
//  BulletParticle.h
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Particle.h"

@class GameModel;
@class Environment;
@class Particles;

@interface BulletParticle : NSObject <Particle>
{
@public
	GLKVector2 position;
	int damage;
	
@protected
	GLKVector2 velocity;
	GLuint positionAttribute;
	
	GameModel *model;
	Environment *env;
	
	unsigned destructionRadius;
	
	int precision;
	
	int stepX;
	int stepY;
	
	int widthBound;
	int heightBound;
	
}

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;

- (void)calculateStep:(int[2]) movement;

@end
