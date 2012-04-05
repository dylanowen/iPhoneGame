//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

#import "MatrixFunctions.h"

#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"
#import "VAOLoader.h"

#import "Background.h"
#import "Environment.h"
#import "JoyStick.h"
#import "ToggleJoyStick.h"
#import "Button.h"
#import "Tracker.h"
#import "Player.h"
#import "Zombie.h"

#import "BouncyMachineGun.h"
#import "MachineGun.h"
#import "ShotGun.h"
#import "BouncyShotGun.h"
#import "Sniper.h"

#import "Particles.h"
#import "BulletParticle.h"
#import "BloodParticle.h"
#import "Text.h"

#import "Pickups.h"

#import "Settings.h"
#import "HighScore.h"

#define NUMBER_OF_ENEMIES 15

@interface GameModel()
{
	float viewWidth;
	float viewHeight;
	
	Weapon *currentGun;
	
	Background *background;
}

@property (strong, nonatomic) NSMutableArray	 *enemies;
@property (strong, nonatomic) NSMutableArray	 *zombieTracker;
@property (strong, nonatomic) Text *killDisplay;

@end

@implementation GameModel

@synthesize view = _view;

@synthesize textureLoader = _textureLoader;
@synthesize effectLoader = _effectLoader;
@synthesize bufferLoader = _bufferLoader;
@synthesize vaoLoader = _vaoLoader;

@synthesize env = _env;
@synthesize particles = _particles;
@synthesize player = _player;
@synthesize enemies = _enemies;
@synthesize zombieTracker = _enemyTrackers;
@synthesize controls = _controls;
@synthesize killDisplay = _killDisplay;

@synthesize zombieKills = _zombieKills;

- (id)initWithView:(UIView *) view
{
	self = [super init];
	if(self)
	{
		self.view = view;
		
		staticProjection = GLKMatrix4MakeOrtho(0, STATIC_VIEW_WIDTH, STATIC_VIEW_HEIGHT, 0, 0, 10);
		dynamicProjection = CenterOrtho(0, 0);

		self.textureLoader = [[TextureLoader alloc] init];
		self.effectLoader = [[EffectLoader alloc] init];
		self.bufferLoader = [[BufferLoader alloc] init];
		self.vaoLoader = [[VAOLoader alloc] init];
		
		background = [[Background alloc] initWithModel:self];
		self.env = [[Environment alloc] initWithModel: self];
		self.particles = [[Particles alloc] initWithModel: self];
		self.controls = [[Controls alloc] initWithModel: self];
		
		pickups = [[Pickups alloc] initWithModel:self];
		
		self.player = [[Player alloc] initWithModel:self position:GLKVector2Make(ENV_WIDTH / 2, 100)];
		
		[self.env deleteRadius:20 x:(ENV_WIDTH / 2) y:100];
		
		self.enemies = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ENEMIES];
		self.zombieTracker = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ENEMIES];
		GLKVector2 trackScale = GLKVector2Make(DYNAMIC_VIEW_WIDTH / self.view.bounds.size.width, DYNAMIC_VIEW_HEIGHT / self.view.bounds.size.height);
		for(unsigned i = 0; i < NUMBER_OF_ENEMIES; i++)
		{
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, self.player->position)) < 80);
			[self.enemies addObject:[[Zombie alloc] initWithModel:self position:newPosition]];
			[self.zombieTracker addObject:[[Tracker alloc] initWithScale: trackScale width: DYNAMIC_VIEW_WIDTH height: DYNAMIC_VIEW_HEIGHT red: 0.0f green: 0.35f blue: 0.0f model:self]];
			[self.env deleteRadius:20 x:newPosition.x y:newPosition.y];
		}
		
		_zombieKills = 0;
		
		Settings *settings = [Settings sharedManager];
		switch ([settings weapon]) {
			case 1:
            currentGun = [[Sniper alloc] initWithParticles:self.particles];
            break;
			case 2:
            currentGun = [[MachineGun alloc] initWithParticles:self.particles];
            break;
			case 3:
            currentGun = [[ShotGun alloc] initWithParticles:self.particles];
            break;
			case 4:
            currentGun = [[BouncyShotGun alloc] initWithParticles:self.particles];
            break;
			default:
            currentGun = [[BouncyMachineGun alloc] initWithParticles:self.particles];
            break;
		}
		
		self.killDisplay = [[Text alloc] initWithModel:self text:@"kills 0" position:GLKVector2Make(5, 5)];
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time
{
	//do all the main stuff of the game
	if(self.player.health <= 0 || [self.enemies count] == 0)
	{
		HighScore *temp = [HighScore sharedManager];
		temp.score = self.zombieKills;
		return NO;
	}
	
	//it's negative because up is negative...
	if(self.controls.move->velocity.y < -0.5f)
	{
		[self.player jump];
	}
	
	self.player->movement.x = self.controls.move->velocity.x * 60;
	//self.player->movement.y = self.controls.move->velocity.y * 5;
	
	self.player->look = self.controls.look->velocity;
	
	//setup the projectionMatrix for everything (it has to happen first)
	[self.player update: time];
	MoveOrthoVector(&dynamicProjection, self.player->position);
	
	//generate a new bullet
	self.player->shoot = self.controls.look->toggle;
	if(self.controls.look->toggle)
	{
		[currentGun shootAtPosition:self.player->position direction: self.controls.look->velocity];
		//[self.particles addHealingEffect:self.player->position];
	}

	
	[self.particles updateWithLastUpdate: time];
	
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		Character *temp = [self.enemies objectAtIndex:i];
		if(![((Zombie *) temp) update: time projection:dynamicProjection])
		{
			[self.particles addBloodWithPosition:temp->position power:150 colorType:BloodColorRed count:8];
			[pickups addZombieSkullWithPosition:temp->position];

			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, self.player->position)) < 140);
	 
			[temp respawn:newPosition];
			//[indexes addIndex: i];
		}
		[[self.zombieTracker objectAtIndex:i] updateTrackee: temp->position center: self.player->position];
	}
	
	[pickups update:time];
	
	[currentGun update:time];
	
	return YES;
}

- (void)setZombieKills:(int)zombieKills
{
	_zombieKills = zombieKills;
	if(_zombieKills % 5 == 0)
	{
		self.player.health += 150;
		[self.particles addHealingEffect:self.player->position];
	}
	self.killDisplay.str = [[NSString alloc] initWithFormat:@"kills %d", zombieKills];
}

- (bool)checkCharacterHit:(BulletParticle *) bullet
{
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		if([[self.enemies objectAtIndex:i] checkBullet:bullet])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)render
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	[background render];

	[self.env render];
	
	[self.player render];
	
	[self.enemies makeObjectsPerformSelector:@selector(render)];
	[pickups render];
	[self.particles render];
	[self.zombieTracker makeObjectsPerformSelector:@selector(render)];
	[self.killDisplay render];
	
	[self.controls render];
	//debug
	/*
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
	*/
}

@end
