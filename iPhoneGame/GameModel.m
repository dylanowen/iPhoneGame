//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

@synthesize view = _view;
@synthesize effect = _effect;
@synthesize projectionMatrix = _projectionMatrix;

@synthesize env = _env;
@synthesize controls = _controls;

- (id)initWithView:(UIView *) view
{
	self = [super init];
	if(self)
	{
		self.view = view;
		
		self.effect = [[GLKBaseEffect alloc] init];
		self.env = [[Environment alloc] initWithModel: self];
		self.controls = [[Controls alloc] initWithModel: self];
		
		left = -10.0f;
		right = left + VIEW_WIDTH;
		top = -10.0f;
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
	
	//[self.effect prepareToDraw];
	
	[self.env render];
	[self.controls render];
	
	
}

-(GLKMatrix4)projectionMatrix
{
	return GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

/*
- (void)touchesBegan:(CGPoint) point
{
	//account for our own coordinate system
	int x = (int) point.x / 2 + left;
	int y = (int) point.y / 2 + top;
	[self.env deleteRadius: (arc4random() % 15) + 5 x:x y:y];
	//[self.env deleteRadius: 10 x:5 y:5];
	NSLog(@"(%f, %f)", point.x, point.y);
}
*/

@end
