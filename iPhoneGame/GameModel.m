//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

#import "Environment.h"
#import "JoyStick.h"

@interface GameModel()
{
	float left, right, bottom, top;
	float viewWidth;
	float viewHeight;
	
	CGPoint deleter;
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
		
		left = 0.0f;
		right = left + VIEW_WIDTH;
		top = 0.0f;
		bottom = top + VIEW_HEIGHT;
		
		
		deleter = CGPointMake(20, 20);
		
		return self;
	}
	return nil;
}

- (void)update
{
	//do all the main stuff of the game
	left += self.controls.move->velocity.x / 8;
	top += self.controls.move->velocity.y / 8;
	if(left < -10.0f)
	{
		left = -10.0f;
	}
	else if(left + VIEW_WIDTH > ENV_WIDTH + 10)
	{
		left = ENV_WIDTH+ 10 - VIEW_WIDTH;
	}
	if(top < -10.0f)
	{
		top = -10.0f;
	}
	else if(top + VIEW_HEIGHT > ENV_HEIGHT + 10)
	{
		top = ENV_HEIGHT + 10 - VIEW_HEIGHT;
	}
	
	right = left + VIEW_WIDTH;
	bottom = top + VIEW_HEIGHT;
	
	self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
	
	deleter.x += self.controls.look->velocity.x / 8;
	deleter.y += self.controls.look->velocity.y / 8;
	if(deleter.x < 0)
	{
		deleter.x = 0;
	}
	else if(deleter.x > ENV_WIDTH)
	{
		deleter.x = ENV_WIDTH;
	}
	if(deleter.y < 0)
	{
		deleter.y = 0;
	}
	else if(deleter.y > ENV_HEIGHT)
	{
		deleter.y = ENV_HEIGHT;
	}
	
	[self.env deleteRadius: 10 x:deleter.x y:deleter.y];
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
