//
//  JoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

#import "GameConstants.h"

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
		
		
		
		
		
		unsigned size = 8 * 2 * sizeof(float);
		float *joystickVertices = malloc(size);
		float *textureVertices = malloc(size);

		joystickVertices[0] = JOY_LENGTH;
		joystickVertices[1] = 0;
		joystickVertices[2] = JOY_LENGTH;
		joystickVertices[3] = JOY_LENGTH;
		joystickVertices[4] = 0;
		joystickVertices[5] = JOY_LENGTH;
		joystickVertices[6] = 0;
		joystickVertices[7] = 0;
		
		textureVertices[0] = 1;
		textureVertices[1] = 0;
		textureVertices[2] = 1;
		textureVertices[3] = 1;
		textureVertices[4] = 0;
		textureVertices[5] = 1;
		textureVertices[6] = 0;
		textureVertices[7] = 0;
		
		
		glGenBuffers(1, &vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, size, joystickVertices, GL_STATIC_DRAW);
		
		glGenBuffers(1, &textureVertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, textureVertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, size, textureVertices, GL_STATIC_DRAW);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		free(joystickVertices);
		free(textureVertices);		
		
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

- (void)dealloc
{
	glDeleteBuffers(1, &vertexBuffer);
	glDeleteBuffers(1, &textureVertexBuffer);
}

- (bool)touchesBegan:(GLKVector2) loci
{
	GLKVector2 temp = GLKVector2Subtract(loci, origin);
	if(GLKVector2Length(temp) <= JOY_BOUNDS)
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
		if(GLKVector2Length(temp) > JOY_BOUNDS)
		{
			position = GLKVector2Add(origin, GLKVector2MultiplyScalar(GLKVector2Normalize(temp), JOY_BOUNDS));
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
	float normLength = powf((GLKVector2Length(temp) / (float) JOY_BOUNDS), 2);
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
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, textureVertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
