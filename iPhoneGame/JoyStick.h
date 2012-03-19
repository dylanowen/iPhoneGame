//
//  JoyStick.h
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define JOY_BOUNDS 40
#define JOY_LENGTH 50
#define JOY_LENGTH_HALF JOY_LENGTH / 2

@class GLKBaseEffect;

@interface JoyStick : NSObject
{
@public
	GLKVector2 velocity;
@protected
	GLKVector2 position;
	
	GLKVector2 lastTouch;
	GLKVector2 origin;
	
	CGRect region;
	
	float radius;
	
	GLKTextureInfo *circleTexture;
	
	GLuint vertexBuffer;
	GLuint textureVertexBuffer;
}

- (id)initWithCenter:(GLKVector2) posit view:(UIView *) view;

- (bool)touchesBegan:(GLKVector2) loci;
- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (void)touchesCancelled;

- (void)render;

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (GLKVector2) calculateVelocity;

@end
