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
	
	GLKMatrix4 projection;
	
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
}

@property (nonatomic) int health;

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;
- (void)respawn:(GLKVector2) posit;
- (void)update:(float) time;
- (BOOL)checkBullet:(BulletParticle *) bullet;
- (void)jump;
- (void)render;
- (void)renderCharacter;
- (void)renderHealth;

@end
