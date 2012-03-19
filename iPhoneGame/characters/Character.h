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

@interface Character : NSObject
{
@protected
	GLKMatrix4 projection;
	
	GLuint characterVertexBuffer;
	GLuint characterTextureBuffer;
	
@public
	GLKVector2 position;
	GLKVector2 movement;
	
	int health;
}

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit texture:(GLKTextureInfo *) text;
- (void)respawn:(GLKVector2) posit;
- (void)update:(float) time;
- (BOOL)checkBullet:(GLKVector2) position;
- (void)render;
- (void)renderCharacter;
- (void)renderHealth;

@end
