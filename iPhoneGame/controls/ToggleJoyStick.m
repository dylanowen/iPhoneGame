//
//  ToggleJoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToggleJoyStick.h"

#import "Globals.h"
#import "GameModel.h"
#import "TextureLoader.h"
#import "BufferLoader.h"
#import "EffectLoader.h"

@interface ToggleJoyStick()
{
	TextureDescription *redCircleTexture;
	TextureDescription *grayCircleTexture;
	
	GLuint boundingVertexBuffer;
}

@end

@implementation ToggleJoyStick

- (id)initWithCenter:(GLKVector2) posit region:(unsigned) regionR grabRegion:(unsigned) grabRegion joyRadius:(float) joyLen toggleBounds:(float) toggleB
{
	self = [super initWithCenter: posit region:regionR grabRegion:grabRegion joyRadius:joyLen];
	if(self)
	{
		toggle = NO;
		toggleBounds = toggleB;
		
		NSString *name = [[NSString alloc] initWithFormat:@"ToggleJoyStick%f", toggleBounds];
		boundingVertexBuffer = [game.bufferLoader getBufferForName:name];
		if(boundingVertexBuffer == 0)
		{
			float vertices[] = {
				toggleBounds, -toggleBounds,
				toggleBounds, toggleBounds,
				-toggleBounds, toggleBounds,
				-toggleBounds, -toggleBounds
			};
			
			boundingVertexBuffer = [game.bufferLoader addBufferForName:name];
			glBindBuffer(GL_ARRAY_BUFFER, boundingVertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
			
		lastVelocity = GLKVector2Make(1.0f, 0.0f);
		redCircleTexture = [game.textureLoader getTextureDescription:@"circleRed.png"];
		grayCircleTexture = [game.textureLoader getTextureDescription:@"circleGray.png"];
		
		return self;
	}
	return nil;
}

- (bool)touchesBegan:(GLKVector2) loci
{
	bool result = [super touchesBegan: loci];
	if(result)
	{
		toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > toggleBounds;
	}
	return result;
}

- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesMoved: loci lastTouch: last];
	if(result)
	{
		toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > toggleBounds;
	}
	return result;
}

- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesEnded: loci lastTouch: last];
	if(result)
	{
		toggle = NO;
	}
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
	if(toggle)
	{
		effect.texture2d0.name = [redCircleTexture getName];
	}
	else
	{
		effect.texture2d0.name = [grayCircleTexture getName];
	}
	
	effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(origin.x, origin.y, 0);

	[effect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, boundingVertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, [redCircleTexture getFrameBuffer:0]);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
	
	[super render];
}

@end
