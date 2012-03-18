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
	float clearer[MAX_DELETE_RADIUS * 2][4];
	
	GLuint positionAttribute;
	GLuint colorAttribute;
	GLuint modelViewUniform;
	
	GLuint vertexBuffer;
	GLuint colorBuffer;
	
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

- (id)initWithModel:(GameModel *) game
{
	self = [super init];
	if(self)
	{
		self.game = game;
		
		float browns[5][3] = {
			{128/256.0f, 68/256.0f, 8/256.0f},
			{152/256.0f ,84/256.0f ,20/256.0f},
			{144/256.0f ,80/256.0f ,16/256.0f},
			{136/256.0f ,72/256.0f ,12/256.0f},
			{120/256.0f ,64/256.0f ,8/256.0f}
		};
		
		//setup the clearing array
		for(unsigned i = 0; i < MAX_DELETE_RADIUS; i++)
		{
			for(unsigned j = 0; j < 4; j++)
			{
				clearer[i][j] = 0.0f;
			}
		}
		
		//load and setup the shaders
		self.program = [[GLProgram alloc] initWithVertexShaderFilename: @"particleShader" fragmentShaderFilename: @"particleShader"];

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
			NSLog(@"Environment shaders loaded.");
		}

		modelViewUniform = [self.program uniformIndex:@"modelViewProjectionMatrix"];
		
		
		//glBindVertexArrayOES(gVAO);
		
		//the size is the width * height * components of vertices
		unsigned vertexBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2;
		unsigned colorBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4;
		
		float *vertices = malloc(vertexBufferSize);
		float *colors = malloc(colorBufferSize);

		for(unsigned i = 0; i < ENV_WIDTH; i++)
		{
			for(unsigned j = 0; j < ENV_HEIGHT; j++)
			{
				unsigned off = i * ENV_HEIGHT + j;
				unsigned offVertices = off * 2;
				unsigned offColor = off * 4;
				
				vertices[offVertices + 0] = (float) i;
				vertices[offVertices + 1] = (float) j;
				
				int randomBrown = (arc4random() % 5);
				colors[offColor + 0] = browns[randomBrown][0];
				colors[offColor + 1] = browns[randomBrown][1];
				colors[offColor + 2] = browns[randomBrown][2];
				colors[offColor + 3] = 1.0f;
				
				dirt[i][j] = YES;
			}
		}
		
		
		glGenBuffers(1, &vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertexBufferSize, vertices, GL_STATIC_DRAW);
		
		glGenBuffers(1, &colorBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
		glBufferData(GL_ARRAY_BUFFER, colorBufferSize, colors, GL_DYNAMIC_DRAW);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		
		NSLog(@"%fMBs of vertex data %fMBs of color data", (float) (sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2) / 1000 / 1000, (float) (sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4) / 1000 / 1000);
		
		//remove vertexBufferData we don't need its data anymore because it's in a buffer
		free(colors);
		free(vertices);
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	glDeleteBuffers(1, &vertexBuffer);
	glDeleteBuffers(1, &colorBuffer);
}

- (void)deleteRadius:(int) radius x:(int) x y:(int) y
{
	radius = (radius > MAX_DELETE_RADIUS)?MAX_DELETE_RADIUS:radius; //keep the radius in bounds
	int tempY, i = -radius, iEnd = radius, j, jEnd;
	unsigned offset;
    
	//keep inside bounds
	if((i + x) < 1)
	{
		i = 1 - x;
	}
	if(iEnd + x > (ENV_WIDTH - 1))
	{
		iEnd = ENV_WIDTH - 1 - x;
	}
	
	glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
	while(i < iEnd)
	{
		tempY = (int) sqrt((radius * radius) - (i * i));
		
		//more bound checking
		if(tempY > 0)
		{
			if(y - tempY < 1)
			{
				j = 1;
				jEnd = tempY + y - 1;
			}
			else if(y + tempY > (ENV_HEIGHT - 1))
			{
				//error here if the destruction is larger than the environment height
				j = y - tempY;
				jEnd = tempY + ENV_HEIGHT - 1 - y;
			}
			else
			{
				j = y - tempY;
				jEnd = tempY * 2;
			}
		
			offset = ((i + x) * ENV_HEIGHT + j) * 4 * sizeof(float);
			tempY = jEnd * 4 * sizeof(float);
		
			//clear out the buffer
			glBufferSubData(GL_ARRAY_BUFFER, offset, tempY, clearer);
		
			//clear our own local array
			jEnd += j;
			while(j < jEnd)
			{
				dirt[i + x][j] = NO;
				j++;
			}
		}
		i++;
	}
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)changeColor:(float[4]) newColor x:(int) x y:(int) y
{
	unsigned offset;
	unsigned length = 3 * sizeof(float);
	unsigned change = 4 * sizeof(float);

	glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
	//original position
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (x * ENV_HEIGHT + y) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//left
	x--;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (x * ENV_HEIGHT + y) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//right
	x += 2;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (x * ENV_HEIGHT + y) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//up
	x--;
	y--;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (x * ENV_HEIGHT + y) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//down
	y += 2;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (x * ENV_HEIGHT + y) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
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
	//use VAO's
	[self.program use];
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);	
	glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
	glEnableVertexAttribArray(colorAttribute);
	glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glUniformMatrix4fv(modelViewUniform, 1, 0, self.game.projectionMatrix.m);
	
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(colorAttribute);
	glDisableVertexAttribArray(positionAttribute);
	
	//debug stuff
	/*
	float debugVertices[ENV_WIDTH * ENV_HEIGHT * 2];
	float debugColor[ENV_WIDTH * ENV_HEIGHT * 4];
	for(unsigned i = 0; i < ENV_WIDTH; i++)
	{
		for(unsigned j = 0; j < ENV_HEIGHT; j++)
		{
			unsigned offset = i * ENV_HEIGHT + j;
			debugVertices[offset * 2 + 0] = i;
			debugVertices[offset * 2 + 1] = j;
			
			debugColor[offset * 4 + 0] = 1.0f;
			debugColor[offset * 4 + 1] = 1.0f;
			debugColor[offset * 4 + 2] = 1.0f;
			if(dirt[i][j])
			{
				debugColor[offset * 4 + 3] = 0.1f;
			}
			else
			{
				debugColor[offset * 4 + 3] = 0.0f;
			}
		}
	}
	[self.program use];
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, debugVertices);
	glEnableVertexAttribArray(colorAttribute);
	glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, debugColor);
	glUniformMatrix4fv(modelViewUniform, 1, 0, self.game.projectionMatrix.m);
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);
	glDisableVertexAttribArray(colorAttribute);
	glDisableVertexAttribArray(positionAttribute);
	*/
}

@end
