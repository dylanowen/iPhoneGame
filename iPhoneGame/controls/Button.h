//
//  Button.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define BUTTON_LENGTH 40
#define BUTTON_LENGTH_HALF BUTTON_LENGTH / 2

@class GameModel;
@class TextureDescription;

@interface Button : NSObject
{
@public
	bool pressed;
@protected
	GLKBaseEffect *effect;
	
	GLKVector2 position;
	
	GLKVector2 lastTouch;
	
	float radius;
	
	TextureDescription *buttonTexture;
	
	GLuint vertexBuffer;
}

- (id)initWithCenter:(GLKVector2) posit model:(GameModel *) model;

- (bool)touchesBegan:(GLKVector2) loci;
- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (void)touchesCancelled;

- (void)render;

@end
