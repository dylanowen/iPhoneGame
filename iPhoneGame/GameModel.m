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
@synthesize projectionMatrix = _projectionMatrix;

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
	//left += 1;
	//right += 1;
	//bottom += 2;
	//top += 2;
	self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)render
{
	glClearColor(0.2, 0.2, 0.2, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];	
	
	[self.effect prepareToDraw];
}

-(GLKMatrix4)projectionMatrix
{
	return GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)touchesBegan:(CGPoint) point
{
	//account for our own coordinate system
	[self.env deleteRadius: (arc4random() % 15) + 5 x:((int) point.x / 2) y:((int) point.y / 2)];
	//[self.env deleteRadius: 10 x:5 y:5];
}

@end
