//
//  Button.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Button.h"

#import "Globals.h"
#import "GameConstants.h"
#import "GameModel.h"
#import "TextureLoader.h"
#import "BufferLoader.h"
#import "EffectLoader.h"

@interface Button()
{
	GLKMatrix4 modelview;
}
@end

@implementation Button

- (id)initWithCenter:(GLKVector2) posit texture:(NSString *) textName radius:(unsigned) rad callback:(void(^)(bool result))back
{
	self = [super init];
	if(self)
	{
		position = posit;
		//assume that the control effect has already been generated
		effect = [game.effectLoader getEffectForName:@"ControlEffect"];
		
		lastTouch = GLKVector2Make(-1, -1);
		
		callback = [back copy];
		
		radius = (float) rad;
		
		vertexBuffer = [game.bufferLoader getBufferForName:@"Button"];
		if(vertexBuffer == 0)
		{
			float vertices[] = {
				radius, -radius,
				radius, radius,
				-radius, radius,
				-radius, -radius
			};
			vertexBuffer = [game.bufferLoader addBufferForName:@"Button"];
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		radius += 5.0f;
		down = NO;
		
		buttonTexture = [game.textureLoader getTextureDescription:textName];
		
		modelview = GLKMatrix4MakeTranslation(position.x, position.y, 0);
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	callback = nil;
}

- (bool)touchesBegan:(GLKVector2) loci
{
	GLKVector2 temp = GLKVector2Subtract(loci, position);
	if(GLKVector2Length(temp) <= radius)
	{
		down = !down;
		callback(down);
		lastTouch = loci;
		return YES;
	}
	
	return NO;
}

- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	if(GLKVector2AllEqualToVector2(lastTouch, last))
	{
		lastTouch = loci;
		
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
	lastTouch = GLKVector2Make(-1, -1);
}

- (void)render
{
	/*interleave joystick data*/
	effect.transform.modelviewMatrix = modelview;
	effect.texture2d0.name = [buttonTexture getName];
	
	[effect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	if(down)
	{
		glBindBuffer(GL_ARRAY_BUFFER, [buttonTexture getFrameBuffer:1]);
	}
	else
	{
		glBindBuffer(GL_ARRAY_BUFFER, [buttonTexture getFrameBuffer:0]);
	}
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
