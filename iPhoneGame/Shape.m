//
//  Shape.m
//  iPhoneGame
//
//  Created by Laura Cantu on 2/19/12.
//  Copyright (c) 2012 University of California, Davis. All rights reserved.
//

#import "Shape.h"

#import "GameModel.h"

@implementation Shape

@synthesize numVertices = _numVertices;
@synthesize vertices = _vertices;
@synthesize gameModel = _gameModel;


- (id)initWithGameModel:(GameModel *) model
{
	self = [super init];
	if(self)
	{
		self.gameModel = model;
		color = GLKVector4Make(1,1,1,1);
		return self;
	}
	return nil;
}

- (int)numVertices
{
	return 0;
}

- (GLKVector2 *)vertices
{
	if(vertexData == nil)
	{
		vertexData = [NSMutableData dataWithLength:sizeof(GLKVector2) * self.numVertices];
	}
	return [vertexData mutableBytes];
}

- (GLKVector4 *)vertexColors
{
	if(vertexColorData == nil)
	{
		vertexColorData = [NSMutableData dataWithLength:sizeof(GLKVector4) * self.numVertices];
	}
	return [vertexColorData mutableBytes];
}

- (void)render
{
	self.gameModel.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);
	[self.gameModel.effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribColor);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, self.vertexColors);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, self.vertices);
  	glDrawArrays(GL_TRIANGLE_FAN, 0, self.numVertices);
	glDisable(GLKVertexAttribPosition);
}

@end
