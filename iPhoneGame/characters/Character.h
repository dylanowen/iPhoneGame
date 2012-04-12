//
//  Character.h
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define CHARACTER_WIDTH 9
#define CHARACTER_HEIGHT 13

@class GameModel;
@class Environment;
@class BulletParticle;
@class TextureDescription;

@interface Character : NSObject
{
@protected
	Environment *env;
	
	GLKBaseEffect *textureEffect;
	GLKBaseEffect *healthEffect;
	TextureDescription *texture;
	
	GLuint characterVertexBuffer;
	GLuint characterTextureBuffer;
	
	float jumpHeight;
	
	float animateTimer;
	int currentFrame;
	
@public
	GLKVector2 position;
	GLKVector2 movement;
	GLKVector2 velocity;
}

@property (nonatomic) int health;

- (id)initWithPosition:(GLKVector2) posit;
- (void)respawn:(GLKVector2) posit;
- (void)update;
- (void)updateVelocity;
- (BOOL)checkBullet:(BulletParticle *) bullet;
- (void)jump;
- (void)render;
- (void)renderCharacter;
- (void)renderHealth;

@end
