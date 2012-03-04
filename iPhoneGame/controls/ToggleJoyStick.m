//
//  ToggleJoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToggleJoyStick.h"

@interface ToggleJoyStick()
{
	GLKTextureInfo *redCircleTexture;
	float boundingVertices[8];
}

@end

@implementation ToggleJoyStick

- (id)initWithCenter:(GLKVector2) posit view:(UIView *) view
{
	self = [super initWithCenter: posit view: view];
	if(self)
	{
		toggle = NO;
		
		boundingVertices[0] = JOY_BOUNDS + 20;
		boundingVertices[1] = -JOY_BOUNDS - 20;
		boundingVertices[2] = JOY_BOUNDS + 20;
		boundingVertices[3] = JOY_BOUNDS + 20;
		boundingVertices[4] = -JOY_BOUNDS - 20;
		boundingVertices[5] = JOY_BOUNDS + 20;
		boundingVertices[6] = -JOY_BOUNDS - 20;
		boundingVertices[7] = -JOY_BOUNDS - 20;
		
		NSError *error;
		redCircleTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"circleRed.png"].CGImage options:nil error:&error];
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
	bool result = [super touchesBegan: loci];
	toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > TOGGLE_BOUNDS;
	return result;
}

- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesMoved: loci lastTouch: last];
	toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > TOGGLE_BOUNDS;
	return result;
}

- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesEnded: loci lastTouch: last];
	toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > TOGGLE_BOUNDS;
	return result;
}

- (void)touchesCancelled
{
	[super touchesCancelled];
	toggle = NO;
}

- (GLKVector2) calculateVelocity
{
	//I figure for the toggle joystick there wont be power associated with shooting so no matter what it's 1
	return GLKVector2Normalize(GLKVector2Subtract(position, origin));
}

- (void)render
{	
	
	//NSLog(@"%f, %f", origin.x - JOY_LENGTH_HALF, origin.y - JOY_LENGTH_HALF);
	self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
	self.effect.texture2d0.target = GLKTextureTarget2D;
	if(toggle)
	{
		self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(origin.x, origin.y, 0);
		self.effect.texture2d0.name = redCircleTexture.name;
		
		[self.effect prepareToDraw];
		
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, boundingVertices);
	
		glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
		glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureVertices);
	
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
		glDisableVertexAttribArray(GLKVertexAttribPosition);	
		glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
	}
	
	self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - JOY_LENGTH_HALF, position.y - JOY_LENGTH_HALF, 0);
	self.effect.texture2d0.name = circleTexture.name;
	
	[self.effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, joystickVertices);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureVertices);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);	
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

@end
