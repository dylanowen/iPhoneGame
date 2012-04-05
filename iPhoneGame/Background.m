//
//  Background.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Background.h"

#import "GameModel.h"
#import "TextureLoader.h"
#import "BufferLoader.h"
#import "EffectLoader.h"

@interface Background()
{
	GameModel *game;
	
	GLKBaseEffect *textureEffect;
	TextureDescription *texture;
	
	GLuint vertexBuffer;
	GLuint textureBuffer;
	
	GLuint vao;
}

@end

@implementation Background

- (id)initWithModel:(GameModel *) model
{
	self = [super init];
	if(self)
	{
		game = model;
		
		textureEffect = [game.effectLoader getEffectForName:@"TextureEffect"];
		if(textureEffect == nil)
		{
			textureEffect = [game.effectLoader addEffectForName:@"TextureEffect"];
			textureEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
			textureEffect.texture2d0.target = GLKTextureTarget2D;
		}
		
		texture = [model.textureLoader getTextureDescription:@"background.png"];
		textureBuffer = [texture getFrameBuffer:0];
		
		vertexBuffer = [game.bufferLoader getBufferForName:@"Background"];
		if(vertexBuffer == 0)
		{
			float z = -10.0f;
			float vertices[] = {
				ENV_WIDTH + DYNAMIC_VIEW_WIDTH / 2, -DYNAMIC_VIEW_HEIGHT / 2, z,
				ENV_WIDTH + DYNAMIC_VIEW_WIDTH / 2, ENV_HEIGHT + DYNAMIC_VIEW_HEIGHT / 2, z,
				-DYNAMIC_VIEW_WIDTH / 2, ENV_HEIGHT + DYNAMIC_VIEW_HEIGHT / 2, z,
				-DYNAMIC_VIEW_WIDTH / 2, -DYNAMIC_VIEW_HEIGHT / 2, z
			};
			vertexBuffer = [game.bufferLoader addBufferForName:@"Background"];
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		glGenVertexArraysOES(1, &vao);
		glBindVertexArrayOES(vao);
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glBindBuffer(GL_ARRAY_BUFFER, textureBuffer);
		glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
		glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		glBindVertexArrayOES(0);
		
		return self;
	}
	return nil;
}

- (void)render
{
	textureEffect.texture2d0.name = [texture getName];
	textureEffect.transform.projectionMatrix = game->dynamicProjection;
	textureEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, 0);
	
	[textureEffect prepareToDraw];
	
	glBindVertexArrayOES(vao);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindVertexArrayOES(0);
}

@end
