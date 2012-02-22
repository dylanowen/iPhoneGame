//
//  Environment.m
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"

#import <GLKit/GLKit.h>

#import "GameModel.h"

@implementation Environment

@synthesize game = _game;

@synthesize width = _width;
@synthesize height = _height;

@synthesize vertexBuffer = _vertexBuffer;
@synthesize colorBuffer = _colorBuffer;

- (id)initWithModel:(GameModel *) game
{
	self = [super init];
	if(self)
	{
		self.game = game;
		
		//the size is the width * height * number of necessary vertices * components of vertices
		unsigned vertexBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2;
		unsigned colorBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4;
		
		color = malloc(colorBufferSize);
		/*
		for(unsigned i = 0; i < ENV_WIDTH; i++)
		{
			//vertex[i] = malloc(sizeof(float) * ENV_HEIGHT * 8);
			//color[i] = malloc(sizeof(float) * ENV_HEIGHT * 4);
			for(unsigned j = 0; j < ENV_HEIGHT; j++)
			{ 
				unsigned offsetColor = (i * ENV_HEIGHT + j) * 4;
				color[offsetColor + 0] = (float) (arc4random() % 10) / 10;
				color[offsetColor + 1] = (float) (arc4random() % 10) / 10;
				color[offsetColor + 2] = (float) (arc4random() % 10) / 10;
				color[offsetColor + 3] = 1.0f;
			}
		}
		*/
		
		float *vertexBufferData = malloc(vertexBufferSize);

		for(unsigned i = 0; i < ENV_WIDTH; i++)
		{
			for(unsigned j = 0; j < ENV_HEIGHT; j++)
			{
				unsigned off = (i * ENV_HEIGHT + j);
				unsigned offsetVertex = off * 2;
				unsigned offsetColor = off * 4;
				
				vertexBufferData[offsetVertex + 0] = (float) i;
				vertexBufferData[offsetVertex + 1] = (float) j;
				
				color[offsetColor + 0] = (float) (i % 10) / 10;
				color[offsetColor + 1] = (float) (j % 10) / 10;
				color[offsetColor + 2] = 0.0f;
				color[offsetColor + 3] = 1.0f;
			}
		}
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertexBufferSize, vertexBufferData, GL_STATIC_DRAW);
		
		glGenBuffers(1, &_colorBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _colorBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, colorBufferSize, color, GL_DYNAMIC_DRAW);
		
		NSLog(@"%fMBs of vertex data %fMBs of color data", (float) vertexBufferSize / 1000 / 1000, (float) colorBufferSize / 1000 / 1000);
		
		//remove this we don't need this data anymore because it's in a buffer
		free(vertexBufferData);
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	free(color);
}

- (void)delete:(CGPoint) point radius:(unsigned) radius
{
	glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
	unsigned maxWidth = radius * 4 * 2;
	float *temp = malloc(sizeof(float) * maxWidth);
	for(unsigned i = 0; i < maxWidth; i++)
	{
		temp[i] = 0.0f;
	}
	for(unsigned i = point.x - radius; i <= point.x + radius && i < ENV_WIDTH; i++)
	{
		unsigned offset = (i * ENV_HEIGHT + point.y - radius) * 4;
		color[offset + 0] = 0.0f;
		color[offset + 1] = 0.0f;
		color[offset + 2] = 0.0f;
		color[offset + 3] = 0.0f;
		glBufferSubData(GL_ARRAY_BUFFER, offset * sizeof(float), sizeof(float) * maxWidth, temp);
	}
	
	NSLog(@"%f, %f", point.x, point.y);
	
	free(temp);
}

- (void)render
{
	//assume that [self.effect prepareToDraw] has already been called
	glEnable(GL_POINT_SPRITE_OES);
	
	glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	
	glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	glEnableVertexAttribArray(GLKVertexAttribColor);
	
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);
	
	glUseProgram(self.game->_program);
	
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);
	
	glDisable(GLKVertexAttribPosition);
	glDisable(GLKVertexAttribColor);
}


@end
