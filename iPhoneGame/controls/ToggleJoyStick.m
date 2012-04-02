//
//  ToggleJoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToggleJoyStick.h"
#import "GameModel.h"
#import "TextureLoader.h"
#import "BufferLoader.h"
#import "EffectLoader.h"

@interface ToggleJoyStick()
{
	TextureDescription *redCircleTexture;
	
	GLuint boundingVertexBuffer;
}

@end

@implementation ToggleJoyStick

- (id)initWithCenter:(GLKVector2) posit region:(unsigned) regionR model:(GameModel *) game
{
	self = [super initWithCenter: posit region:regionR grabRegion:regionR model:game];
	if(self)
	{
		toggle = NO;
		
		boundingVertexBuffer = [game.bufferLoader getBufferForName:@"ToggleJoyStick"];
		if(boundingVertexBuffer == 0)
		{
			float vertices[] = {
				TOGGLE_BOUNDS, -TOGGLE_BOUNDS,
				TOGGLE_BOUNDS, TOGGLE_BOUNDS,
				-TOGGLE_BOUNDS, TOGGLE_BOUNDS,
				-TOGGLE_BOUNDS, -TOGGLE_BOUNDS
			};
			
			
			boundingVertexBuffer = [game.bufferLoader addBufferForName:@"ToggleJoyStick"];
			glBindBuffer(GL_ARRAY_BUFFER, boundingVertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		redCircleTexture = [game.textureLoader getTextureDescription:@"circleRed.png"];
		
		return self;
	}
	return nil;
}

- (bool)touchesBegan:(GLKVector2) loci
{
	bool result = [super touchesBegan: loci];
	if(result)
	{
		toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > TOGGLE_BOUNDS;
	}
	return result;
}

- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesMoved: loci lastTouch: last];
	if(result)
	{
		toggle = GLKVector2Length(GLKVector2Subtract(position, origin)) > TOGGLE_BOUNDS;
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
		effect.texture2d0.name = [texture getName];
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
