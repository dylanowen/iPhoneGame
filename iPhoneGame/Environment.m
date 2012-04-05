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
	float restorer[MAX_DELETE_RADIUS * 2][4];
	
	GLuint positionAttribute;
	GLuint colorAttribute;
	GLuint modelViewUniform;
	
	GLuint vertexBuffer;
	GLuint colorBuffer;
	
	GLuint vao;
	//GLuint gVAO;
}


@property (nonatomic, strong) GameModel *game;
@property (nonatomic, strong) GLProgram *program;

- (void)editRadius:(int) radius x:(int) x y:(int) y delete:(bool) del;

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
			{183/256.0f, 123/256.0f, 63/256.0f},
			{212/256.0f ,144/256.0f ,80/256.0f},
			{204/256.0f ,140/256.0f ,76/256.0f},
			{196/256.0f ,132/256.0f ,72/256.0f},
			{175/256.0f ,119/256.0f ,63/256.0f}
		};
		
		//setup the clearing array
		for(unsigned i = 0; i < MAX_DELETE_RADIUS; i++)
		{
			int randomBrown = (arc4random() % 5);
			restorer[i][0] = browns[randomBrown][0] - 0.3f;
			restorer[i][1] = browns[randomBrown][1] - 0.1f;
			restorer[i][2] = browns[randomBrown][2];
			restorer[i][3] = 1.0f;
			
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
		
		//the size is the width * height * components of vertices
		unsigned vertexBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 3;
		unsigned colorBufferSize = sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4;
		
		float *vertices = malloc(vertexBufferSize);
		float *colors = malloc(colorBufferSize);

		for(unsigned i = 0; i < ENV_WIDTH; i++)
		{
			for(unsigned j = 0; j < ENV_HEIGHT; j++)
			{
				unsigned off = i * ENV_HEIGHT + j;
				unsigned offVertices = off * 3;
				unsigned offColor = off * 4;
				
				vertices[offVertices + 0] = (float) i;
				vertices[offVertices + 1] = (float) j;
				vertices[offVertices + 2] = -9.0f;
				
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
		
		glGenVertexArraysOES(1, &vao);
		glBindVertexArrayOES(vao);
		
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glEnableVertexAttribArray(positionAttribute);
		glVertexAttribPointer(positionAttribute, 3, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
		glEnableVertexAttribArray(colorAttribute);
		glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		glBindVertexArrayOES(0);
		
		NSLog(@"%.3fMBs of vertex data %.3fMBs of color data", (float) (sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 2) / 1000 / 1000, (float) (sizeof(float) * ENV_WIDTH * ENV_HEIGHT * 4) / 1000 / 1000);
		
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
	[self editRadius:radius x:x y:y delete:YES];
}

- (void)restoreRadius:(int) radius x:(int) x y:(int) y
{
	[self editRadius:radius x:x y:y delete:NO];
}

- (void)editRadius:(int) radius x:(int) x y:(int) y delete:(bool) del
{
	radius = (radius > MAX_DELETE_RADIUS)?MAX_DELETE_RADIUS:radius; //keep the radius in bounds
	int tempY, i = -radius, iEnd = radius, j, jEnd;
	unsigned offset;
	float **oWA;
	bool collisionState;
	
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
			glBufferSubData(GL_ARRAY_BUFFER, offset, tempY, oWA);
		
			//clear our own local array
			jEnd += j;
			while(j < jEnd)
			{
				dirt[i + x][j] = collisionState;
				j++;
			}
		}
		i++;
	}
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)editRect:(bool) del leftX:(int) x topY:(int) y width:(int) width height:(int) height
{
	float **oWA;
	bool collisionState;
	
	height = (height > MAX_DELETE_RADIUS * 2)?MAX_DELETE_RADIUS * 2:height; //keep the height in bounds
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
	for(int i = x; i < endX; i++)
	{
		//clear out the buffer
		glBufferSubData(GL_ARRAY_BUFFER, (i * ENV_HEIGHT + y) * 4 * sizeof(float), height * 4 * sizeof(float), oWA);
		
		//clear our own local array
		for(int j = y; j < endY; j++)
		{
			dirt[i][j] = collisionState;
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

- (void)render
{
	[self.program use];
	
	glBindVertexArrayOES(vao);
	
	glUniformMatrix4fv(modelViewUniform, 1, 0, self.game->dynamicProjection.m);
	
	glDrawArrays(GL_POINTS, 0, ENV_WIDTH * ENV_HEIGHT);
	
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
