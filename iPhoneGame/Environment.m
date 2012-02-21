//
//  Environment.m
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"

#import <GLKit/GLKit.h>

@implementation Environment

@synthesize width = _width;
@synthesize height = _height;

@synthesize vertexBuffer = _vertexBuffer;
@synthesize colorBuffer = _colorBuffer;

@synthesize vertexBufferSize = _vertexBufferSize;
@synthesize colorBufferSize = _colorBufferSize;

- (id)initWithWidth:(int) width height:(int) height
{
	self = [super init];
	if(self)
	{
		self.width = width;
		self.height = height;
		
		//the size is the width * height * number of necessary vertices * components of vertices
		self.vertexBufferSize = sizeof(float) * self.width * self.height * 6 * 2;
		self.colorBufferSize = sizeof(float) * self.width * self.height * 6 * 4;
		
		color = malloc(self.colorBufferSize / 6);
		for(unsigned i = 0; i < self.width; i++)
		{
			//vertex[i] = malloc(sizeof(float) * self.height * 8);
			//color[i] = malloc(sizeof(float) * self.height * 4);
			for(unsigned j = 0; j < self.height; j++)
			{ 
				unsigned offsetColor = (i * self.height + j) * 4;
				color[offsetColor + 0] = (float) (arc4random() % 10) / 10;
				color[offsetColor + 1] = (float) (arc4random() % 10) / 10;
				color[offsetColor + 2] = (float) (arc4random() % 10) / 10;
				color[offsetColor + 3] = 1.0f;
			}
		}
		
		
		float *vertexBufferData = malloc(self.vertexBufferSize);
		float *colorBufferData = malloc(self.colorBufferSize);
		for(unsigned i = 0; i < self.width; i++)
		{
			//vertex[i] = malloc(sizeof(float) * self.height * 8);
			//color[i] = malloc(sizeof(float) * self.height * 4);
			for(unsigned j = 0; j < self.height; j++)
			{
				unsigned off = (i * self.height + j);
				unsigned offsetVertex = off * 12;
				unsigned offsetColor = off * 24;
				unsigned offsetRealColor = off * 4;
				
				vertexBufferData[offsetVertex + 0] = (float) i;
				vertexBufferData[offsetVertex + 1] = (float) j;
				vertexBufferData[offsetVertex + 2] = (float) i + 1.0f;
				vertexBufferData[offsetVertex + 3] = (float) j + 1.0f;
				vertexBufferData[offsetVertex + 4] = (float) i + 1.0f;
				vertexBufferData[offsetVertex + 5] = (float) j;
				
				vertexBufferData[offsetVertex + 6] = (float) i;
				vertexBufferData[offsetVertex + 7] = (float) j;
				vertexBufferData[offsetVertex + 8] = (float) i + 1.0f;
				vertexBufferData[offsetVertex + 9] = (float) j + 1.0f;
				vertexBufferData[offsetVertex + 10] = (float) i;
				vertexBufferData[offsetVertex + 11] = (float) j + 1.0f;
				
				colorBufferData[offsetColor + 0] = color[offsetRealColor + 0];
				colorBufferData[offsetColor + 1] = color[offsetRealColor + 1];
				colorBufferData[offsetColor + 2] = color[offsetRealColor + 2];
				colorBufferData[offsetColor + 3] = color[offsetRealColor + 3];
				
				colorBufferData[offsetColor + 4] = color[offsetRealColor + 0];
				colorBufferData[offsetColor + 5] = color[offsetRealColor + 1];
				colorBufferData[offsetColor + 6] = color[offsetRealColor + 2];
				colorBufferData[offsetColor + 7] = color[offsetRealColor + 3];
				
				colorBufferData[offsetColor + 8] = color[offsetRealColor + 0];
				colorBufferData[offsetColor + 9] = color[offsetRealColor + 1];
				colorBufferData[offsetColor + 10] = color[offsetRealColor + 2];
				colorBufferData[offsetColor + 11] = color[offsetRealColor + 3];
				
				colorBufferData[offsetColor + 12] = color[offsetRealColor + 0];
				colorBufferData[offsetColor + 13] = color[offsetRealColor + 1];
				colorBufferData[offsetColor + 14] = color[offsetRealColor + 2];
				colorBufferData[offsetColor + 15] = color[offsetRealColor + 3];
				
				colorBufferData[offsetColor + 16] = color[offsetRealColor + 0];
				colorBufferData[offsetColor + 17] = color[offsetRealColor + 1];
				colorBufferData[offsetColor + 18] = color[offsetRealColor + 2];
				colorBufferData[offsetColor + 19] = color[offsetRealColor + 3];
				
				colorBufferData[offsetColor + 20] = color[offsetRealColor + 0];
				colorBufferData[offsetColor + 21] = color[offsetRealColor + 1];
				colorBufferData[offsetColor + 22] = color[offsetRealColor + 2];
				colorBufferData[offsetColor + 23] = color[offsetRealColor + 3];
			}
		}
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, self.vertexBufferSize, vertexBufferData, GL_STATIC_DRAW);
		
		glGenBuffers(1, &_colorBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _colorBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, self.colorBufferSize, colorBufferData, GL_DYNAMIC_DRAW);
		
		//remove this we don't need this data anymore because it's in a buffer
		free(vertexBufferData);
		free(colorBufferData);
		
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
	float *temp = malloc(sizeof(float) * 24);
	for(unsigned i = 0; i < 24; i++)
	{
		temp[i] = 0.0f;
	}
	for(unsigned i = point.x - radius; i <= point.x + radius && i < self.width; i++)
	{
		for(unsigned j = point.y - radius; j <= point.y - radius && j < self.height; j++)
		{
			unsigned off = (i * self.height + j);
			unsigned offsetColor = off * 24;
			unsigned offsetRealColor = off * 4;
			color[offsetRealColor + 0] = 0.0f;
			color[offsetRealColor + 1] = 0.0f;
			color[offsetRealColor + 2] = 0.0f;
			color[offsetRealColor + 3] = 0.0f;
			glBufferSubData(GL_ARRAY_BUFFER, offsetColor * sizeof(float), sizeof(float) * 24, temp);
		}
	}
	free(temp);
}

- (void)render
{
	//assume that [self.effect prepareToDraw] has already been called
	glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	
	glBindBuffer(GL_ARRAY_BUFFER, self.colorBuffer);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	glEnableVertexAttribArray(GLKVertexAttribColor);
	
	glDrawArrays(GL_TRIANGLES, 0, self.width * self.height * 6);
	glDisable(GLKVertexAttribPosition);
}


@end
