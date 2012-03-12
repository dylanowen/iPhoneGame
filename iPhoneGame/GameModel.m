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
#import "ToggleJoyStick.h"
#import "Tracker.h"
#import "Character.h"
#import "Particles.h"

@interface GameModel()
{
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
@synthesize particles = _particles;
@synthesize player = _player;
@synthesize controls = _controls;

- (id)initWithView:(UIView *) view
{
	self = [super init];
	if(self)
	{
		self.view = view;
		
		self.env = [[Environment alloc] initWithModel: self];
		self.particles = [[Particles alloc] initWithModel: self];
		self.controls = [[Controls alloc] initWithModel: self];
		//GLKVector2 trackScale = GLKVector2Make(VIEW_WIDTH / self.view.bounds.size.width, VIEW_HEIGHT / self.view.bounds.size.height);
		//self.tempTracker = [[Tracker alloc] initWithScale: trackScale width: VIEW_WIDTH height: VIEW_HEIGHT red: 0.0f green: 0.8f blue: 0.0f];
		
		self.player = [[Character alloc] initWithModel:self position:GLKVector2Make(ENV_WIDTH / 2, 20)];
		[self.env deleteRadius:300 x:(ENV_WIDTH / 2) y:(ENV_HEIGHT / 2)];
		
		self.projectionMatrix = GLKMatrix4MakeOrtho(0, VIEW_WIDTH, VIEW_HEIGHT, 0, 1, -1);
		
		return self;
	}
	return nil;
}

- (void)updateWithLastUpdate:(float) time
{
	//do all the main stuff of the game
	
	self.player->velocity.x = self.controls.move->velocity.x * 7;
	//setup the projectionMatrix for everything (it has to happen first)
	self.projectionMatrix = [self.player update: time];
	
	[self.particles updateWithLastUpdate: time];
    
	//generate a new bullet
	if(self.controls.look->toggle)
	{
		
		GLKVector2 temp = GLKVector2Add(self.player->position, GLKVector2MultiplyScalar(self.controls.look->velocity, 5));
		NSLog(@"(%f, %f) (%f, %f) (%f, %f)", self.player->position.x, self.player->position.y, temp.x, temp.y, self.controls.look->velocity.x, self.controls.look->velocity.y);
		[self.particles 
			addBulletWithPosition:GLKVector2Add(self.player->position, GLKVector2MultiplyScalar(self.controls.look->velocity, 7)) 
			velocity:GLKVector2MultiplyScalar(self.controls.look->velocity, 250) destructionRadius:5];

		//[self.particles addBloodWithPosition:GLKVector2Make((left + right) / 2, (top + bottom) / 2) power:50];
	}
	
	//NSLog(@"(%f, %f)", self.player->position.x, self.player->position.y);
	
	
	//[self.tempTracker updateTrackee: self.player->position center: GLKVector2Make((right + left) / 2, (bottom + top) / 2)];
}

- (void)render
{
	glClearColor(0.2, 0.2, 0.2, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];
	[self.player render];
	[self.particles render];
	[self.controls render];
	//[self.tempTracker render];
	
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

@end
