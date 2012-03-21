//
//  JoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "TextureLoader.h"
#import "BufferLoader.h"
#import "EffectLoader.h"


@implementation JoyStick

- (id)initWithCenter:(GLKVector2) posit model:(GameModel *) game
{
	self = [super init];
	if(self)
	{
		position = origin = posit;
		//assume that the control effect has already been generated
		effect = [game.effectLoader getEffectForName:@"ControlEffect"];
		
		lastTouch = GLKVector2Make(-1, -1);
		velocity = GLKVector2Make(0, 0);
		
		vertexBuffer = [game.bufferLoader getBufferForName:@"JoyStick"];
		if(vertexBuffer == 0)
		{
			float vertices[] = {
				JOY_LENGTH, 0,
				JOY_LENGTH, JOY_LENGTH,
				0, JOY_LENGTH,
				0, 0
			};
			vertexBuffer = [game.bufferLoader addBufferForName:@"JoyStick"];
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}

		texture = [game.textureLoader getTextureDescription:@"circle.png"];
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	glDeleteBuffers(1, &vertexBuffer);
}

- (bool)touchesBegan:(GLKVector2) loci
{
	GLKVector2 temp = GLKVector2Subtract(loci, origin);
	if(GLKVector2Length(temp) <= JOY_BOUNDS + 10)
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
	/*interleave joystick data*/
	effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - JOY_LENGTH_HALF, position.y - JOY_LENGTH_HALF, 0);
	effect.texture2d0.name = [texture getName];
	
	[effect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, [texture getFrameBuffer:0]);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
