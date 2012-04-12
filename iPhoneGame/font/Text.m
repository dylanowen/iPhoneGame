//
//  Text.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Text.h"

#import "Globals.h"
#import "GameModel.h"
#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"

#define MAX_STRING_LENGTH 100

@interface Text()
{
	GLuint vertexBuffer;
	
	TextureDescription *texture;
	
	GLKBaseEffect *effect;
	
	GLKVector2 position;
	
	unsigned buffers[MAX_STRING_LENGTH];
	unsigned stringLength;
}

@end

@implementation Text

- (id)initWithModel:(GameModel *)model position:(GLKVector2) posit text:(NSString *)text
{
	self = [super init];
	if(self)
	{
		position = posit;
		
		vertexBuffer = [model.bufferLoader getBufferForName:@"Font"];
		if(vertexBuffer == 0)
		{
			float vertices[] = {
				12, 0,
				12, 18,
				0, 18,
				0, 0
			};
			vertexBuffer = [model.bufferLoader addBufferForName:@"Font"];
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		texture = [model.textureLoader getTextureDescription:@"font.png"];
		effect = [model.effectLoader getEffectForName:@"Font"];
		if(effect == nil)
		{
			effect = [model.effectLoader addEffectForName:@"Font"];
			effect.transform.projectionMatrix = model->staticProjection;
			effect.texture2d0.name = [texture getName];
			effect.texture2d0.envMode = GLKTextureEnvModeReplace;
			effect.texture2d0.target = GLKTextureTarget2D;
		}
		
		[self setText:text];
		return self;
	}
	return nil;
}

- (void)setText:(NSString *) text
{
	const char *cStr = [text cStringUsingEncoding:NSASCIIStringEncoding];
	stringLength = [text length];
	
	for(unsigned i = 0; i < stringLength; i++)
	{
		if(cStr[i] != ' ')
		{
			if(cStr[i] >= '0' && cStr[i] <= '9')
			{
				buffers[i] = [texture getFrameBuffer:(cStr[i] - '0' + 26)];
			}
			else
			{
				buffers[i] = [texture getFrameBuffer:(cStr[i] - 'a')];
			}
		}
		else
		{
			buffers[i] = 0;
		}
	}
}

- (void)render
{
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	for(unsigned i = 0; i < stringLength; i++)
	{
		if(buffers[i] != 0)
		{
			effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(i * 10 + position.x, position.y, 0);
			[effect prepareToDraw];
			
			glBindBuffer(GL_ARRAY_BUFFER, buffers[i]);
			glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
			glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
			
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		}
	}
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
