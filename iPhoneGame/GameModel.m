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
@property (strong, nonatomic) NSMutableArray	 *enemies;
@property (strong, nonatomic) NSMutableArray	 *enemyTrackers;

@end

@implementation GameModel

@synthesize view = _view;
@synthesize projectionMatrix = _projectionMatrix;

@synthesize env = _env;
@synthesize tempTracker = _tempTracker;
@synthesize particles = _particles;
@synthesize player = _player;
@synthesize enemies = _enemies;
@synthesize enemyTrackers = _enemyTrackers;
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
		//
		//;
		
		self.player = [[Character alloc] initWithModel:self position:GLKVector2Make(ENV_WIDTH / 2, 200)];
		
		[self.env deleteRadius:20 x:(ENV_WIDTH / 2) y:200];
		
		self.enemies = [[NSMutableArray alloc] initWithCapacity:5];
		self.enemyTrackers = [[NSMutableArray alloc] initWithCapacity:5];
		GLKVector2 trackScale = GLKVector2Make(VIEW_WIDTH / self.view.bounds.size.width, VIEW_HEIGHT / self.view.bounds.size.height);
		for(unsigned i = 0; i < 5; i++)
		{
			int ranX = arc4random() % (ENV_WIDTH - 20) + 10;
			int ranY = arc4random() % (ENV_HEIGHT - 20) + 10;
			[self.enemies addObject:[[Character alloc] initWithModel:self position:GLKVector2Make(ranX, ranY)]];
			[self.enemyTrackers addObject:[[Tracker alloc] initWithScale: trackScale width: VIEW_WIDTH height: VIEW_HEIGHT red: 0.8f green: 0.1f blue: 0.1f]];
			[self.env deleteRadius:20 x:ranX y:ranY];
		}
		
		//[self.env deleteRadius:MAX_DELETE_RADIUS x:(ENV_WIDTH / 2) y:400];
		//[self.env deleteRadius:MAX_DELETE_RADIUS x:(ENV_WIDTH / 2) y:600];
		
		self.projectionMatrix = GLKMatrix4MakeOrtho(0, VIEW_WIDTH, VIEW_HEIGHT, 0, 1, -1);
		
		return self;
	}
	return nil;
}

- (void)updateWithLastUpdate:(float) time
{
	//do all the main stuff of the game
	
	self.player->movement.x = self.controls.move->velocity.x * 60;
	self.player->movement.y = self.controls.move->velocity.y * 10;
	//setup the projectionMatrix for everything (it has to happen first)
	self.projectionMatrix = [self.player update: time];
	
	[self.particles updateWithLastUpdate: time];
	
	
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		Character *temp = [self.enemies objectAtIndex:i];
		if(![temp update: time projection:self.projectionMatrix])
		{
			[indexes addIndex: i];
		}
		[[self.enemyTrackers objectAtIndex:i] updateTrackee: temp->position center: self.player->position];
	}
	[self.enemies removeObjectsAtIndexes: indexes];
	[self.enemyTrackers removeObjectsAtIndexes: indexes];
    
	//generate a new bullet
	if(self.controls.look->toggle)
	{
		
		//GLKVector2 temp = GLKVector2Add(self.player->position, GLKVector2MultiplyScalar(self.controls.look->velocity, 5));
		//NSLog(@"(%f, %f) (%f, %f) (%f, %f)", self.player->position.x, self.player->position.y, temp.x, temp.y, self.controls.look->velocity.x, self.controls.look->velocity.y);
		[self.particles 
			addBulletWithPosition:GLKVector2Add(self.player->position, GLKVector2MultiplyScalar(self.controls.look->velocity, 7)) 
			velocity:GLKVector2MultiplyScalar(self.controls.look->velocity, 300) destructionRadius:10];

		//[self.particles addBloodWithPosition:GLKVector2Make((left + right) / 2, (top + bottom) / 2) power:50];
	}
	
	//NSLog(@"(%f, %f)", self.player->position.x, self.player->position.y);
	
	
	
}

- (bool)checkCharacterHit:(int) x y:(int) y
{
	GLKVector2 position = GLKVector2Make(x, y);
	
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		if([[self.enemies objectAtIndex:i] checkBullet:position])
		{
			[self.particles addBloodWithPosition:position power:75];
		}
	}
	
	return NO;
}

- (void)render
{
	glClearColor(0.2, 0.2, 0.2, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];
	[self.enemies makeObjectsPerformSelector:@selector(render)];
	[self.player render];
	[self.particles render];
	[self.controls render];
	[self.enemyTrackers makeObjectsPerformSelector:@selector(render)];
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
