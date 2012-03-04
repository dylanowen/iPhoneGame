//
//  JoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

#import "GameConstants.h"

@interface JoyStick()
{
	GLKVector2 position;
	
	GLKVector2 lastTouch;
	GLKVector2 origin;
	
	CGRect region;
	
	float radius;
	
	float joystickVertices[8];
	float boundingVertices[8];
	float textureVertices[8];
	
	GLKTextureInfo *circleTexture;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (GLKVector2) calculateVelocity;

@end

@implementation JoyStick

@synthesize view = _view;
@synthesize effect = _effect;

- (id)initWithCenter:(GLKVector2) posit view:(UIView *) view
{
	self = [super init];
	if(self)
	{
		position = origin = posit;
		self.view = view;
		
		self.effect = [[GLKBaseEffect alloc] init];
		
		lastTouch = GLKVector2Make(-1, -1);
		velocity = GLKVector2Make(0, 0);
		
		//NSLog(@"%@ (%f, %f: %f %f)", self, region.origin.x, region.origin.y, region.size.width, region.size.height);
		
		joystickVertices[0] = JOY_LENGTH;
		joystickVertices[1] = 0;
		joystickVertices[2] = JOY_LENGTH;
		joystickVertices[3] = JOY_LENGTH;
		joystickVertices[4] = 0;
		joystickVertices[5] = JOY_LENGTH;
		joystickVertices[6] = 0;
		joystickVertices[7] = 0;
		
		boundingVertices[0] = JOY_LENGTH * 2;
		boundingVertices[1] = -JOY_LENGTH;
		boundingVertices[2] = JOY_LENGTH * 2;
		boundingVertices[3] = JOY_LENGTH * 2;
		boundingVertices[4] = -JOY_LENGTH;
		boundingVertices[5] = JOY_LENGTH * 2;
		boundingVertices[6] = -JOY_LENGTH;
		boundingVertices[7] = -JOY_LENGTH;
		
		textureVertices[0] = 1;
		textureVertices[1] = 0;
		textureVertices[2] = 1;
		textureVertices[3] = 1;
		textureVertices[4] = 0;
		textureVertices[5] = 1;
		textureVertices[6] = 0;
		textureVertices[7] = 0;
		
		self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.bounds.size.width, self.view.bounds.size.height, 0, 1, -1);
		
		NSError *error;
		circleTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"circle.png"].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
		}
		
		return self;
	}
	return nil;
}

- (bool)touchesBegan:(GLKVector2) loci
{
	GLKVector2 temp = GLKVector2Subtract(loci, origin);
	if(GLKVector2Length(temp) <= JOY_LENGTH)
	{
		position = lastTouch = loci;
		velocity = [self calculateVelocity];
		return YES;
	}

	return NO;
}

- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	if(GLKVector2AllEqualToVector2(lastTouch, last))
	{
		GLKVector2 temp = GLKVector2Subtract(loci, origin);
		if(GLKVector2Length(temp) > JOY_LENGTH)
		{
			position = GLKVector2Add(origin, GLKVector2MultiplyScalar(GLKVector2Normalize(temp), JOY_LENGTH));
		}
		else
		{
			position = loci;
		}
		lastTouch = loci;
		velocity = [self calculateVelocity];
		return YES;
	}
	return NO;
}

- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	if(GLKVector2AllEqualToVector2(lastTouch, loci) || GLKVector2AllEqualToVector2(lastTouch, last))
	{
		[self touchesCancelled];
		return YES;
	}
	return NO;
}

- (void)touchesCancelled
{
	position = origin;
	lastTouch = GLKVector2Make(-1, -1);
	velocity = GLKVector2Make(0, 0);
}

- (GLKVector2) calculateVelocity
{
	//based on position and origin so make sure to update position before calling this
	GLKVector2 temp = GLKVector2Subtract(position, origin);
	float normLength = powf((GLKVector2Length(temp) / 40.0f), 2);
	return GLKVector2MultiplyScalar(GLKVector2Normalize(temp), normLength);
}

- (void)render
{	
	self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - JOY_LENGTH_HALF, position.y - JOY_LENGTH_HALF, 0);
	//NSLog(@"%f, %f", origin.x - JOY_LENGTH_HALF, origin.y - JOY_LENGTH_HALF);
	self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
	self.effect.texture2d0.target = GLKTextureTarget2D;
	self.effect.texture2d0.name = circleTexture.name;
	
	[self.effect prepareToDraw];
	
	/*glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, boundingVertices);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureVertices);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);	
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
	*/
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, joystickVertices);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureVertices);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);	
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

@end
