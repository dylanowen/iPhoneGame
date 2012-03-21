//
//  Text.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Text.h"

#import "GameModel.h"
#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"

@interface Text()
{
	GLuint vertexBuffer;
	
	TextureDescription *texture;
	
	GLKBaseEffect *effect;
	
	GameModel *model;
	GLKVector2 position;
}

@end

@implementation Text

@synthesize str = _str;

- (id)initWithModel:(GameModel *) mod text:(NSString *)text position:(GLKVector2) posit
{
	self = [super init];
	if(self)
	{
		self.str = text;
		
		model = mod;
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
		}
		
		texture = [model.textureLoader getTextureDescription:@"font.png"];
		effect = [model.effectLoader getEffectForName:@"Font"];
		if(effect == nil)
		{
			effect = [model.effectLoader addEffectForName:@"Font"];
			effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, model.view.bounds.size.width, model.view.bounds.size.height, 0, 1, -1);
			effect.texture2d0.name = [texture getName];
			effect.texture2d0.envMode = GLKTextureEnvModeReplace;
			effect.texture2d0.target = GLKTextureTarget2D;
		}
		
		return self;
	}
	return nil;
}

- (void)setStr:(NSString *)input
{
	_str = [input lowercaseString];
}

- (void)render
{
	
	const char *cStr = [self.str cStringUsingEncoding:NSASCIIStringEncoding];
	
	for(unsigned i = 0; i < [self.str length]; i++)
	{
		if(cStr[i] != ' ')
		{
		effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(i * 10 + position.x, position.y, 0);
		[effect prepareToDraw];
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		if(cStr[i] >= '0' && cStr[i] <= '9')
		{
			glBindBuffer(GL_ARRAY_BUFFER, [texture getFrameBuffer:(cStr[i] - '0' + 26)]);
		}
		else
		{
			glBindBuffer(GL_ARRAY_BUFFER, [texture getFrameBuffer:(cStr[i] - 'a')]);
		}
		glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
		glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
		glDisableVertexAttribArray(GLKVertexAttribPosition);
		}
	}
}

@end