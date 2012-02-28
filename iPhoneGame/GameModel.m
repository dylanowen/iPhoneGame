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
#import "Tracker.h"
#import "Character.h"

@interface GameModel()
{
	float left, right, bottom, top;
	float viewWidth;
	float viewHeight;
	
	GLKVector2 deleter;
}

@property (strong, nonatomic) Tracker *enemyTracker;

@property (strong, nonatomic) Character *player;
@property (strong, nonatomic) NSMutableArray *physObjects;

@end

@implementation GameModel

@synthesize view = _view;
@synthesize effect = _effect;
@synthesize projectionMatrix = _projectionMatrix;

@synthesize env = _env;
@synthesize enemyTracker = _enemyTracker;
@synthesize physObjects = _physObjects;
@synthesize player = _player;
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
		self.physObjects = [[NSMutableArray arrayWithCapacity: 0] init];
		GLKVector2 trackScale = GLKVector2Make(VIEW_WIDTH / self.view.bounds.size.width, VIEW_HEIGHT / self.view.bounds.size.height);
		self.enemyTracker = [[Tracker alloc] initWithScale: trackScale width: VIEW_WIDTH height: VIEW_HEIGHT red: 8.0f green: 0.0f blue: 0.0f];
		
		self.player = [[Character alloc] initWithModel:self position:CGPointMake(20, 20)];
		
		left = 0.0f;
		right = left + VIEW_WIDTH;
		top = 0.0f;
		bottom = top + VIEW_HEIGHT;
		
		
		deleter = GLKVector2Make(20, 20);
		
		[self.env deleteRadius: 10 x:30 y:5];
		
		return self;
	}
	return nil;
}

- (void)updateWithLastUpdate:(float) time
{
	self.effect.transform.projectionMatrix = self.projectionMatrix;

	//do all the main stuff of the game
	left += self.controls.move->velocity.x * 7;
	top += self.controls.move->velocity.y * 7;
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
	
	deleter.x += self.controls.look->velocity.x * 7;
	deleter.y += self.controls.look->velocity.y * 7;
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
	
	[self.player updateAndKeep: time];
	
	for(unsigned i = 0; i < [self.physObjects count]; i++)
	{
		//update the physics stuff
	}
	
	[self.enemyTracker updateTrackee: deleter center: GLKVector2Make((right + left) / 2, (bottom + top) / 2)];
}

- (void)render
{
	glClearColor(0.2, 0.2, 0.2, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];
	[self.player render];
	[self.physObjects makeObjectsPerformSelector:@selector(render)];
	[self.controls render];
	[self.enemyTracker render];
	
	//debug
	switch(glGetError())
	{
		case GL_NO_ERROR:
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
