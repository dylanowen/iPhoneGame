//
//  Environment.m
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"

#import <GLKit/GLKit.h>

#import "Globals.h"
#import "GameModel.h"
#import "GLProgram.h"

@interface Environment()
{
	GameModel *game;
	
	GLProgram *program;
	
	float clearer[MAX_DELETE_RADIUS * 2][4];
	float restorer[MAX_DELETE_RADIUS * 2][MAX_DELETE_RADIUS * 2][4];
	
	//stored y, x
	bool dirt[ENV_HEIGHT][ENV_WIDTH];
	
	GLuint positionAttribute;
	GLuint colorAttribute;
	GLuint modelViewUniform;
	
	GLuint vertexBuffer;
	GLuint colorBuffer;
	
	GLuint vao;
	//GLuint gVAO;
}

@end

@implementation Environment

@synthesize width = _width;
@synthesize height = _height;

- (id)initWithModel:(GameModel *) model
{
	self = [super init];
	if(self)
	{
		game = model;
		
		float browns[5][3] = {
			{183/256.0f, 123/256.0f, 63/256.0f},
			{212/256.0f ,144/256.0f ,80/256.0f},
			{204/256.0f ,140/256.0f ,76/256.0f},
			{196/256.0f ,132/256.0f ,72/256.0f},
			{175/256.0f ,119/256.0f ,63/256.0f}
		};
		
		//setup the clearing array
		for(unsigned i = 0; i < MAX_DELETE_RADIUS * 2; i++)
		{
			for(unsigned j = 0; j < MAX_DELETE_RADIUS * 2; j++)
			{
				int randomBrown = (arc4random() % 5);
				restorer[i][j][0] = browns[randomBrown][0] + 0.05f;
				restorer[i][j][1] = browns[randomBrown][1] + 0.05f;
				restorer[i][j][2] = browns[randomBrown][2];
				restorer[i][j][3] = 1.0f;
			}
			
			for(unsigned j = 0; j < 4; j++)
			{
				clearer[i][j] = 0.0f;
			}
		}
		
		//load and setup the shaders
		program = [[GLProgram alloc] initWithVertexShaderFilename: @"particleShader" fragmentShaderFilename: @"particleShader"];

		positionAttribute = [program addAttribute: @"position"];
		colorAttribute = [program addAttribute: @"color"];
		
		if(![program link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [program programLog]); 
			NSLog(@"Frag Log: %@", [program fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [program vertexShaderLog]);
			program = nil;
		}
		else
		{
			NSLog(@"Environment shaders loaded.");
		}

		modelViewUniform = [program uniformIndex:@"modelViewProjectionMatrix"];
		
		//the size is the width * height * components of vertices
		unsigned vertexBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2;
		unsigned colorBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4;
		
		float *vertices = malloc(vertexBufferSize);
		float *colors = malloc(colorBufferSize);

		for(unsigned j = 0; j < ENV_HEIGHT; j++)
		{
			for(unsigned i = 0; i < ENV_WIDTH; i++)
			{
				unsigned off = j * ENV_WIDTH + i;
				unsigned offVertices = off * 2;
				unsigned offColor = off * 4;
				
				vertices[offVertices + 0] = (float) i;
				vertices[offVertices + 1] = (float) j;
				
				int randomBrown = (arc4random() % 5);
				colors[offColor + 0] = browns[randomBrown][0];
				colors[offColor + 1] = browns[randomBrown][1];
				colors[offColor + 2] = browns[randomBrown][2];
				colors[offColor + 3] = 1.0f;
				
				dirt[j][i] = YES;
			}
		}
		
		glGenBuffers(1, &vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertexBufferSize, vertices, GL_STATIC_DRAW);
		
		glGenBuffers(1, &colorBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
		glBufferData(GL_ARRAY_BUFFER, colorBufferSize, colors, GL_DYNAMIC_DRAW);
		
		glGenVertexArraysOES(1, &vao);
		glBindVertexArrayOES(vao);
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glEnableVertexAttribArray(positionAttribute);
		glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
		glEnableVertexAttribArray(colorAttribute);
		glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		glBindVertexArrayOES(0);
		
		NSLog(@"%.3fMBs of vertex data %.3fMBs of color data", (float) (vertexBufferSize) / 1000 / 1000, (float) (colorBufferSize) / 1000 / 1000);
		
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

#define editRadius(sub, col) \
radius = (radius > MAX_DELETE_RADIUS)?MAX_DELETE_RADIUS:radius;\
int tempX, i, iEnd, j = -radius, jEnd = radius;\
unsigned offset;\
\
if((j + y) < 1)\
{\
	j = 1 - y;\
}\
if(jEnd + y > (ENV_HEIGHT - 1))\
{\
	jEnd = ENV_HEIGHT - 1 - y;\
}\
\
glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);\
while(j < jEnd)\
{\
	tempX = (int) sqrt((radius * radius) - (j * j));\
	\
	if(tempX > 0)\
	{\
		if(x - tempX < 1)\
		{\
			i = 1;\
			iEnd = tempX + x - 1;\
		}\
		else if(x + tempX > (ENV_WIDTH - 1))\
		{\
			i = x - tempX;\
			iEnd = tempX + ENV_WIDTH - 1 - x;\
		}\
		else\
		{\
			i = x - tempX;\
			iEnd = tempX * 2;\
		}\
		\
		offset = ((j + y) * ENV_WIDTH + i) * 4 * sizeof(float);\
		tempX = iEnd * 4 * sizeof(float);\
		\
		glBufferSubData(GL_ARRAY_BUFFER, offset, tempX, sub);\
		\
		iEnd += i;\
		while(i < iEnd)\
		{\
			dirt[j + y][i] = col;\
			i++;\
		}\
	}\
	j++;\
}\
glBindBuffer(GL_ARRAY_BUFFER, 0);

- (void)deleteRadius:(int) radius x:(int) x y:(int) y
{
	editRadius(clearer, NO)
}

- (void)restoreRadius:(int) radius x:(int) x y:(int) y
{
	int k = 0;
	editRadius(restorer[k++], YES)
}

- (void)editRect:(bool) del leftX:(int) x topY:(int) y width:(int) width height:(int) height
{
	float **oWA;
	bool collisionState;
	
	width = (width > MAX_DELETE_RADIUS * 2)?MAX_DELETE_RADIUS * 2:width; //keep the width in bounds with the max_delete_radius
	
	if(x < 1)
	{
		x = 1;
	}
	if(y < 1)
	{
		y = 1;
	}
	if(x + width > (ENV_WIDTH - 1))
	{
		width = ENV_WIDTH - 1 - x;
	}
	if(y + height > (ENV_HEIGHT - 1))
	{
		height = ENV_HEIGHT - 1 - y;
	}
	
	if(del)
	{
		oWA = (float **) clearer;
		collisionState = NO;
	}
	else
	{
		oWA = (float **) restorer;
		collisionState = YES;
	}
	
	int endX = x + width;
	int endY = y + height;
	glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
	for(int j = y; j < endY; j++)
	{
		//clear out the buffer
		glBufferSubData(GL_ARRAY_BUFFER, (j * ENV_WIDTH + x) * 4 * sizeof(float), width * 4 * sizeof(float), oWA);
		
		//clear our own local array
		for(int i = x; i < endX; i++)
		{
			dirt[j][i] = collisionState;
		}
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
		offset = (y * ENV_WIDTH + x) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//left
	x--;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (y * ENV_WIDTH + x) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//right
	x += 2;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (y * ENV_WIDTH + x) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//up
	x--;
	y--;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (y * ENV_WIDTH + x) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	//down
	y += 2;
	if(x >= 0 && x < ENV_WIDTH && y >= 0 && y < ENV_HEIGHT)
	{
		offset = (y * ENV_WIDTH + x) * change;
		glBufferSubData(GL_ARRAY_BUFFER, offset, length, newColor);
	}
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (bool)getDirtX:(unsigned) x Y:(unsigned) y
{
	return dirt[y][x];
}

- (void)render:(float) x
{
	[program use];
	
	glBindVertexArrayOES(vao);
	
	glUniformMatrix4fv(modelViewUniform, 1, 0, game->dynamicProjection.m);
	
	int start = floor(game->screenCenter.y) - DYNAMIC_VIEW_HEIGHT / 2, end = DYNAMIC_VIEW_HEIGHT + 1;
	if(start < 0)
	{
		start = 0;
	}
	else if(end + start > ENV_HEIGHT)
	{
		end = ENV_HEIGHT - start;
	}
	glDrawArrays(GL_POINTS, start * ENV_WIDTH, end * ENV_WIDTH);
	
	glBindVertexArrayOES(0);
	
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
			if(dirt[j][i])
			{
				debugColor[offset * 4 + 3] = 0.1f;
			}
			else
			{
				debugColor[offset * 4 + 3] = 0.0f;
			}
		}
	}
	[program use];
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, debugVertices);
	glEnableVertexAttribArray(colorAttribute);
	glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, debugColor);
	glUniformMatrix4fv(modelViewUniform, 1, 0, game->dynamicProjection.m);
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);
	glDisableVertexAttribArray(colorAttribute);
	glDisableVertexAttribArray(positionAttribute);
	*/
}

@end
