//
//  JoyStick.h
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define JOY_LENGTH 50
#define JOY_LENGTH_HALF JOY_LENGTH / 2

@class GameModel;
@class TextureDescription;

@interface JoyStick : NSObject
{
@public
	GLKVector2 velocity;
@protected
	GLKBaseEffect *effect;
	
	GLKVector2 position;
	
	GLKVector2 lastTouch;
	GLKVector2 origin;
	
	CGRect region;
	
	float radius;
	
	TextureDescription *texture;
	
	unsigned regionRadius;
	unsigned grabRadius;
	
	GLuint vao;
}

- (id)initWithCenter:(GLKVector2) posit region:(unsigned) regionR grabRegion:(unsigned) grabRegion model:(GameModel *) game;

- (bool)touchesBegan:(GLKVector2) loci;
- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (void)touchesCancelled;

- (void)render;

- (GLKVector2) calculateVelocity;

@end
