//
//  JoyStick.h
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;
@class TextureDescription;

@interface JoyStick : NSObject
{
@public
	GLKVector2 velocity;
	GLKVector2 lastVelocity;
@protected
	GameModel *game;
	
	GLKBaseEffect *effect;
	
	GLKVector2 position;
	
	GLKVector2 lastTouch;
	GLKVector2 origin;
	
	CGRect region;
	
	float radius;
	
	TextureDescription *texture;
	
	unsigned regionRadius;
	unsigned grabRadius;
	float joyLength;
	
	GLuint vao;
}

- (id)initWithModel:(GameModel *) model center:(GLKVector2) posit region:(unsigned) regionR grabRegion:(unsigned) grabRegion joyRadius:(float) joyLen;

- (bool)touchesBegan:(GLKVector2) loci;
- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (void)touchesCancelled;

- (void)render;

- (GLKVector2) calculateVelocity;

@end
