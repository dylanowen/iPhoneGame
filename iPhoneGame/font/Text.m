//
//  Text.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Text.h"

#import "GameModel.h"

@interface Text()
{
	GLuint vertexBuffer;
	GLuint textureBuffers[40];
	
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
		
		float vertices[] = {
			12, 0,
			12, 18,
			0, 18,
			0, 0
		};
		glGenBuffers(1, &vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
		
		//generate the texture buffers
		for(unsigned i = 0; i < 40; i++)
		{
			float vertices[] = {
				0.025f * (i + 1), 0.0f,
				0.025f * (i + 1), 1.0f,
				0.025f * i, 1.0f,
				0.025f * i, 0.0f
			};
			glGenBuffers(1, &(textureBuffers[i]));
			glBindBuffer(GL_ARRAY_BUFFER, textureBuffers[i]);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
		}
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		effect = [[GLKBaseEffect alloc] init];
		
		NSError *error;
		GLKTextureInfo *fontTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"font.png"].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
		}
		effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, model.view.bounds.size.width, model.view.bounds.size.height, 0, 1, -1);
		effect.texture2d0.name = fontTexture.name;
		effect.texture2d0.envMode = GLKTextureEnvModeReplace;
		effect.texture2d0.target = GLKTextureTarget2D;
		
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
			glBindBuffer(GL_ARRAY_BUFFER, textureBuffers[cStr[i] - '0' + 26]);
		}
		else
		{
			glBindBuffer(GL_ARRAY_BUFFER, textureBuffers[cStr[i] - 'a']);
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
