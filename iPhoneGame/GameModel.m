//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "GameModel.h"

#import "Environment.h"

@interface GameModel()
{
	float left, right, bottom, top;	
}



@end

@implementation GameModel

@synthesize context = _context;
@synthesize effect = _effect;
@synthesize projectionMatrix = _projectionMatrix;

@synthesize env = _env;

- (id)initWithContext:(EAGLContext *) context effect:(GLKBaseEffect *) effect
{
	self = [super init];
	if(self)
	{
		self.effect = effect;
		self.context = context;
		self.env = [[Environment alloc] initWithWidth: 400 height: 400];
		
		left = 0.0f;
		right = left + VIEW_WIDTH;
		top = 0.0f;
		bottom = top + VIEW_HEIGHT;
		
		return self;
	}
	return nil;
}

- (void)update
{
	//do all the main stuff of the game
	self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)render
{
	[self.effect prepareToDraw];
	
	/*
	float vertices[8] = {3, 3,
								3, 100,
								100, 100,
								100, 3};
	float vertices1[8] = {103, 103,
								103, 200,
								200, 200,
								200, 103};
	*/
	
	//glEnableVertexAttribArray(GLKVertexAttribColor);
	//glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, self.vertexColors);
	
	[self.env render];
	
	
	
}

-(GLKMatrix4)projectionMatrix
{
	return GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)touchesBegan:(CGPoint) point
{
	[self.env delete: point radius: 10];
}

@end
