//
//  Button.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Button.h"

@interface Button()
{
	GLKMatrix4 modelview;
}
@end

@implementation Button

- (id)initWithCenter:(GLKVector2) posit effect:(GLKBaseEffect *) effe
{
	self = [super init];
	if(self)
	{
		position = posit;
		effect = effe;
		
		lastTouch = GLKVector2Make(-1, -1);
		
		float joystickVertices[] = {
			BUTTON_LENGTH, 0,
			BUTTON_LENGTH, BUTTON_LENGTH,
			0, BUTTON_LENGTH,
			0, 0
		};
		float textureVertices[] = {
			.5, 0,
			.5, 1,
			0, 1,
			0, 0
		};
		float textureVerticesPressed[] = {
			1, 0,
			1, 1,
			.5, 1,
			.5, 0
		};		
		
		glGenBuffers(1, &vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(joystickVertices), joystickVertices, GL_STATIC_DRAW);
		
		glGenBuffers(1, &textureVertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, textureVertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(textureVertices), textureVertices, GL_STATIC_DRAW);
		
		glGenBuffers(1, &texturePressedVertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, texturePressedVertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(textureVerticesPressed), textureVerticesPressed, GL_STATIC_DRAW);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		NSError *error;
		buttonTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"jump_button.png"].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
		}
		
		pressed = NO;
		modelview = GLKMatrix4MakeTranslation(position.x - BUTTON_LENGTH_HALF, position.y - BUTTON_LENGTH_HALF, 0);
		
		return self;
	}
	return nil;
}

- (bool)touchesBegan:(GLKVector2) loci
{
	GLKVector2 temp = GLKVector2Subtract(loci, position);
	if(GLKVector2Length(temp) <= BUTTON_LENGTH + 10)
	{
		pressed = YES;
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
		pressed = NO;
		lastTouch = loci;
		return YES;
	}
	return NO;
}

- (void)touchesCancelled
{
	pressed = NO;
}

- (void)render
{
	/*interleave joystick data*/
	effect.transform.modelviewMatrix = modelview;
	effect.texture2d0.name = buttonTexture.name;
	
	[effect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	if(pressed)
	{
		glBindBuffer(GL_ARRAY_BUFFER, texturePressedVertexBuffer);
	}
	else
	{
		glBindBuffer(GL_ARRAY_BUFFER, textureVertexBuffer);
	}
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
