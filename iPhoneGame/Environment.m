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
{
	float vertices[ENV_WIDTH][ENV_HEIGHT][2];
	float colors[ENV_WIDTH][ENV_HEIGHT][4];
	
	GLuint gVAO;
}

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
		
		//glBindVertexArrayOES(gVAO);
		
		//the size is the width * height * components of vertices
		//vertexBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2;
		//colorBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4;
		
		//vertices = malloc(vertexBufferSize);
		//color = malloc(colorBufferSize);
		
		
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
		
		//float *vertexBufferData = malloc(vertexBufferSize);

		for(unsigned i = 0; i < ENV_WIDTH; i++)
		{
			for(unsigned j = 0; j < ENV_HEIGHT; j++)
			{				
				vertices[i][j][0] = (float) i;
				vertices[i][j][1] = (float) j;
				
				colors[i][j][0] = (float) (i % 10) / 10;
				colors[i][j][1] = (float) (j % 10) / 10;
				colors[i][j][2] = 0.0f;
				colors[i][j][3] = 1.0f;
			}
		}
		
		/*
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertexBufferSize, vertexBufferData, GL_STATIC_DRAW);
		
		glGenBuffers(1, &_colorBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
		glBufferData(GL_ARRAY_BUFFER, colorBufferSize, color, GL_DYNAMIC_DRAW);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		*/
		
		NSLog(@"%fMBs of vertex data %fMBs of color data", (float) (sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2) / 1000 / 1000, (float) (sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4) / 1000 / 1000);
		
		//remove vertexBufferData we don't need its data anymore because it's in a buffer
		//free(vertexBufferData);
		//glBindVertexArrayOES(0);
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	//free(color);
	//glDeleteBuffers(1, &_vertexBuffer);
	//glDeleteBuffers(1, &_colorBuffer);
}

- (void)delete:(CGPoint) point radius:(unsigned) radius
{
	/*
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
	*/
}

- (void)checkError
{
	switch(glGetError())
	{
		case GL_NO_ERROR:
			NSLog(@"GL_NO_ERROR");
			break;
		case GL_INVALID_ENUM:
			NSLog(@"GL_INVALID_ENUM");
			break;
		case GL_INVALID_VALUE:
			NSLog(@"GL_INVALID_VALUE");
			break;
		case GL_INVALID_OPERATION:
			NSLog(@"GL_INVALID_OPERATION");
			break;
		case GL_STACK_OVERFLOW:
			NSLog(@"GL_STACK_OVERFLOW");
			break;
		case GL_STACK_UNDERFLOW:
			NSLog(@"GL_STACK_UNDERFLOW");
			break;
		case GL_OUT_OF_MEMORY:
			NSLog(@"GL_OUT_OF_MEMORY");
			break;
		default:
			NSLog(@"dunnno");	
	}
}

- (void)render
{
	[self.game.effect prepareToDraw];
	//glEnable(GL_POINT_SPRITE_OES);
	
	//glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	

	//glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
	glEnableVertexAttribArray(GLKVertexAttribColor);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);

	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);

	glUseProgram(self.game->_program);
	
	glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, self.game.projectionMatrix.m);
	glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, self.game.effect.transform.modelviewMatrix.m);

	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);

	//glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribColor);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}


@end
