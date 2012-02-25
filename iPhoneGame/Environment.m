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
#import "GLProgram.h"

@interface Environment()
{
	float vertices[ENV_WIDTH][ENV_HEIGHT][2];
	float colors[ENV_WIDTH][ENV_HEIGHT][4];
	
	GLuint positionAttribute;
	GLuint colorAttribute;
	GLuint modelViewUniform;
	
	//GLuint gVAO;
}


@property (nonatomic, strong) GameModel *game;
@property (nonatomic, strong) GLProgram *program;

@end

@implementation Environment

@synthesize game = _game;
@synthesize program = _program;

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
		self.program = [[GLProgram alloc] initWithVertexShaderFilename: @"environmentShader" fragmentShaderFilename: @"environmentShader"];
		
		float browns[5][3] = {
			{128/256.0f, 68/256.0f, 8/256.0f},
			{152/256.0f ,84/256.0f ,20/256.0f},
			{144/256.0f ,80/256.0f ,16/256.0f},
			{136/256.0f ,72/256.0f ,12/256.0f},
			{120/256.0f ,64/256.0f ,8/256.0f}
		};

		positionAttribute = [self.program addAttribute: @"position"];
		colorAttribute = [self.program addAttribute: @"color"];
		
		if(![self.program link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [self.program programLog]); 
			NSLog(@"Frag Log: %@", [self.program fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [self.program vertexShaderLog]);
			self.program = nil;
		}
		else
		{
			NSLog(@"Environment shaders successfully loaded.");
		}

		modelViewUniform = [self.program uniformIndex:@"modelViewProjectionMatrix"];
		
		
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
				
				int randomBrown = (arc4random() % 5);
				colors[i][j][0] = browns[randomBrown][0];
				colors[i][j][1] = browns[randomBrown][1];
				colors[i][j][2] = browns[randomBrown][2];
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
	int tempX, tempY;
	for(int i = point.x - radius; i <= point.x + radius; i++)
	{
		tempY = i - point.x;
		tempX = (int) sqrt((radius * radius) - (tempY * tempY));
		for(int j = point.y - tempX; j <= point.y + tempX; j++)
		{
			colors[i][j][0] = 0.0f;
			colors[i][j][1] = 0.0f;
			colors[i][j][2] = 0.0f;
			colors[i][j][3] = 0.0f;
		}
	}
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
	[self.program use];
	//glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	

	//glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
	glEnableVertexAttribArray(colorAttribute);
	glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, colors);
	
	glUniformMatrix4fv(modelViewUniform, 1, 0, self.game->projectionMatrix.m);
	
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);

	//glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(colorAttribute);
	glDisableVertexAttribArray(positionAttribute);
}


@end
