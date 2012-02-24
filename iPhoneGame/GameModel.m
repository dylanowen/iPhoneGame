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
	float viewWidth;
	float viewHeight;
}

@end

@implementation GameModel

@synthesize context = _context;
@synthesize effect = _effect;

@synthesize env = _env;

- (id)initWithContext:(EAGLContext *) context effect:(GLKBaseEffect *) effect
{
	self = [super init];
	if(self)
	{
		self.effect = effect;
		self.context = context;
		
		self.env = [[Environment alloc] initWithModel: self];
		
		left = 0.0f;
		right = left + VIEW_HEIGHT;
		top = 0.0f;
		bottom = top + VIEW_WIDTH;
		
		return self;
	}
	return nil;
}

- (void)update
{
	//do all the main stuff of the game
	//left += 1;
	//right += 1;
	//bottom += 2;
	//top += 2;
	projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
	self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)render
{
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];	
	
	[self.effect prepareToDraw];
	
	float vertices[] = {1, 1, 40, 40, 20, 40};
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glDrawArrays(GL_TRIANGLES, 0, 3);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
	
}

- (void)touchesBegan:(CGPoint) point
{
	point.x = (int) point.x / 2;
	point.y = (int) point.y / 2;
	[self.env delete: point radius: 5];
}

@end
