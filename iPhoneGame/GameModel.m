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
#import "Player.h"
#import "Zombie.h"
#import "Particles.h"
#import "BloodParticle.h"

@interface GameModel()
{
	float viewWidth;
	float viewHeight;
	
	float bulletTime;
}

@property (strong, nonatomic) Tracker *tempTracker;

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSMutableArray	 *enemies;
@property (strong, nonatomic) NSMutableArray	 *zombieTracker;

@end

@implementation GameModel

@synthesize view = _view;
@synthesize projectionMatrix = _projectionMatrix;

@synthesize env = _env;
@synthesize tempTracker = _tempTracker;
@synthesize particles = _particles;
@synthesize player = _player;
@synthesize enemies = _enemies;
@synthesize zombieTracker = _enemyTrackers;
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

		//load character textures
		NSError *error;
		GLKTextureInfo *playerTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"character.png"].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
		}
		GLKTextureInfo *zombieTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"zombie.png"].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
		}
		
		self.player = [[Player alloc] initWithModel:self position:GLKVector2Make(ENV_WIDTH / 2, 40) texture:playerTexture];
		
		[self.env deleteRadius:20 x:(ENV_WIDTH / 2) y:40];
		
		self.enemies = [[NSMutableArray alloc] initWithCapacity:15];
		self.zombieTracker = [[NSMutableArray alloc] initWithCapacity:15];
		GLKVector2 trackScale = GLKVector2Make(VIEW_WIDTH / self.view.bounds.size.width, VIEW_HEIGHT / self.view.bounds.size.height);
		for(unsigned i = 0; i < 15; i++)
		{
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, self.player->position)) < 80);
			[self.enemies addObject:[[Zombie alloc] initWithModel:self position:newPosition texture:zombieTexture]];
			[self.zombieTracker addObject:[[Tracker alloc] initWithScale: trackScale width: VIEW_WIDTH height: VIEW_HEIGHT red: 0.8f green: 0.1f blue: 0.1f]];
			[self.env deleteRadius:20 x:newPosition.x y:newPosition.y];
		}
		
		bulletTime = 0;
		
		self.projectionMatrix = GLKMatrix4MakeOrtho(0, VIEW_WIDTH, VIEW_HEIGHT, 0, 1, -1);
		
		return self;
	}
	return nil;
}

- (bool)updateWithLastUpdate:(float) time
{
	//do all the main stuff of the game
	if(self.player->health <= 0 || [self.enemies count] == 0)
	{
		return NO;
	}
	
	
	self.player->movement.x = self.controls.move->velocity.x * 60;
	self.player->movement.y = self.controls.move->velocity.y * 10;
	//setup the projectionMatrix for everything (it has to happen first)
	self.projectionMatrix = [self.player update: time];
	
	[self.particles updateWithLastUpdate: time];
	
	
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		Character *temp = [self.enemies objectAtIndex:i];
		temp->movement = GLKVector2MultiplyScalar(GLKVector2Normalize(GLKVector2Subtract(self.player->position, temp->position)), 30);
		if(arc4random() % 10 == 0)
		{
			GLKVector2 dig = GLKVector2Add(GLKVector2Add(temp->position, GLKVector2Normalize(temp->movement)), GLKVector2Make(0, -4));
			//NSLog(@"(%f %f) + (%f, %f) -> (%f, %f)", temp->position.x, temp->position.y, temp->movement.x, temp->movement.y, dig.x, dig.y);
			[self.env deleteRadius:4 x:dig.x y:dig.y];
			dig = GLKVector2Add(dig, GLKVector2Make(0, 8));
			[self.env deleteRadius:4 x:dig.x y:dig.y];
		}
		if(![((Zombie *) temp) update: time projection:self.projectionMatrix])
		{
			[self.particles addBloodWithPosition:temp->position power:150 colorType:BloodColorBlack count:3];
			[indexes addIndex: i];
		}
		else if(GLKVector2Length(GLKVector2Subtract(self.player->position, temp->position)) < 4)
		{
			self.player->health--;
			[self.particles addBloodWithPosition:self.player->position power:75 colorType:BloodColorRed count:2];
		}
		[[self.zombieTracker objectAtIndex:i] updateTrackee: temp->position center: self.player->position];
	}
	[self.enemies removeObjectsAtIndexes: indexes];
	[self.zombieTracker removeObjectsAtIndexes: indexes];
    
	//generate a new bullet
	if(self.controls.look->toggle && bulletTime > .08)
	{
		[self.particles 
			addBulletWithPosition:GLKVector2Add(self.player->position, GLKVector2MultiplyScalar(self.controls.look->velocity, 7)) 
			velocity:GLKVector2MultiplyScalar(self.controls.look->velocity, 150) destructionRadius:10];
		bulletTime = 0;
	}
	bulletTime += time;
	
	
	return YES;
}

- (bool)checkCharacterHit:(int) x y:(int) y
{
	GLKVector2 position = GLKVector2Make(x, y);
	
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		//make the blood appear 1/2 of the time
		if([[self.enemies objectAtIndex:i] checkBullet:position] && arc4random() % 2 == 0)
		{
			[self.particles addBloodWithPosition:position power:75 colorType:BloodColorGreen];
		}
	}
	
	return NO;
}

- (void)render
{
	glClearColor(0.2, 0.2, 0.2, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];
	[self.player render];
	[self.enemies makeObjectsPerformSelector:@selector(render)];
	[self.particles render];
	[self.controls render];
	[self.zombieTracker makeObjectsPerformSelector:@selector(render)];
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
