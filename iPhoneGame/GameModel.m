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
#import "Bullets.h"

@interface GameModel()
{
	float left, right, bottom, top;
	float viewWidth;
	float viewHeight;
}

@property (strong, nonatomic) Tracker *tempTracker;

@property (strong, nonatomic) Character *player;

@end

@implementation GameModel

@synthesize view = _view;
@synthesize projectionMatrix = _projectionMatrix;

@synthesize env = _env;
@synthesize tempTracker = _tempTracker;
@synthesize bullets = _bullets;
@synthesize player = _player;
@synthesize controls = _controls;

- (id)initWithView:(UIView *) view
{
	self = [super init];
	if(self)
	{
		self.view = view;
		
		self.env = [[Environment alloc] initWithModel: self];
		self.bullets = [[Bullets alloc] initWithModel: self];
		self.controls = [[Controls alloc] initWithModel: self];
		GLKVector2 trackScale = GLKVector2Make(VIEW_WIDTH / self.view.bounds.size.width, VIEW_HEIGHT / self.view.bounds.size.height);
		self.tempTracker = [[Tracker alloc] initWithScale: trackScale width: VIEW_WIDTH height: VIEW_HEIGHT red: 0.0f green: 0.8f blue: 0.0f];
		
		self.player = [[Character alloc] initWithModel:self position:GLKVector2Make(20, 20)];
		
		left = 0.0f;
		right = left + VIEW_WIDTH;
		top = 0.0f;
		bottom = top + VIEW_HEIGHT;
		
		return self;
	}
	return nil;
}

- (void)updateWithLastUpdate:(float) time
{
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
	
	//generate a new bullet
	if(self.controls.look->velocity.x != 0 || self.controls.look->velocity.y != 0)
	{
		[self.bullets addBulletWithPosition:GLKVector2Make((left + right) / 2, (top + bottom) / 2) velocity:GLKVector2MultiplyScalar(self.controls.look->velocity, 250) destructionRadius:10];
		[self.bullets addBulletWithPosition:GLKVector2Make((left + right) / 2, (top + bottom) / 2) velocity:GLKVector2MultiplyScalar(self.controls.look->velocity, -250) destructionRadius:10];
		[self.bullets addBulletWithPosition:GLKVector2Make((left + right) / 2, (top + bottom) / 2) velocity:GLKVector2Multiply(self.controls.look->velocity, GLKVector2Make(250, -250)) destructionRadius:10];
		[self.bullets addBulletWithPosition:GLKVector2Make((left + right) / 2, (top + bottom) / 2) velocity:GLKVector2Multiply(self.controls.look->velocity, GLKVector2Make(-250, 250)) destructionRadius:10];
	}
	
	[self.player updateAndKeep: time];
	[self.bullets updateWithLastUpdate: time];
	
	[self.tempTracker updateTrackee: self.player->position center: GLKVector2Make((right + left) / 2, (bottom + top) / 2)];
}

- (void)render
{
	glClearColor(0.2, 0.2, 0.2, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];
	[self.player render];
	[self.bullets render];
	[self.controls render];
	[self.tempTracker render];
	
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

@end
