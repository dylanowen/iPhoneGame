//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"
#import "VAOLoader.h"

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

#import "Settings.h"
#import "HighScore.h"

#define NUMBER_OF_ENEMIES 10
#define BULLET_TIME_INCREMENT 0.05f

@interface GameModel()
{
	float viewWidth;
	float viewHeight;
	
	int zombieKills;
	
	Weapon *currentGun;
}

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSMutableArray	 *enemies;
@property (strong, nonatomic) NSMutableArray	 *zombieTracker;
@property (strong, nonatomic) Text *killDisplay;

@end

@implementation GameModel

@synthesize view = _view;
@synthesize projectionMatrix = _projectionMatrix;

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

- (id)initWithView:(UIView *) view
{
	self = [super init];
	if(self)
	{
		self.view = view;
		
		self.textureLoader = [[TextureLoader alloc] init];
		self.effectLoader = [[EffectLoader alloc] init];
		self.bufferLoader = [[BufferLoader alloc] init];
		self.vaoLoader = [[VAOLoader alloc] init];
		
		self.env = [[Environment alloc] initWithModel: self];
		self.particles = [[Particles alloc] initWithModel: self];
		self.controls = [[Controls alloc] initWithModel: self];
		
		self.player = [[Player alloc] initWithModel:self position:GLKVector2Make(ENV_WIDTH / 2, 100)];
		
		[self.env deleteRadius:20 x:(ENV_WIDTH / 2) y:100];
		
		self.enemies = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ENEMIES];
		self.zombieTracker = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ENEMIES];
		GLKVector2 trackScale = GLKVector2Make(VIEW_WIDTH / self.view.bounds.size.width, VIEW_HEIGHT / self.view.bounds.size.height);
		for(unsigned i = 0; i < NUMBER_OF_ENEMIES; i++)
		{
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, self.player->position)) < 80);
			[self.enemies addObject:[[Zombie alloc] initWithModel:self position:newPosition]];
			[self.zombieTracker addObject:[[Tracker alloc] initWithScale: trackScale width: VIEW_WIDTH height: VIEW_HEIGHT red: 0.0f green: 0.35f blue: 0.0f model:self]];
			[self.env deleteRadius:20 x:newPosition.x y:newPosition.y];
		}
		
		zombieKills = 0;
		
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
		HighScore *temp = [HighScore sharedManager];
		temp.score = zombieKills;
		return NO;
	}
	
	if(self.controls.jump->pressed)
	{
		[self.player jump];
	}
	
	self.player->movement.x = self.controls.move->velocity.x * 60;
	self.player->movement.y = self.controls.move->velocity.y * 10;
	//setup the projectionMatrix for everything (it has to happen first)
	self.projectionMatrix = [self.player update: time];

	
	[self.particles updateWithLastUpdate: time];
	
	
	//NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.enemies count]; i++)
	{
		Character *temp = [self.enemies objectAtIndex:i];
		temp->movement = GLKVector2MultiplyScalar(GLKVector2Normalize(GLKVector2Subtract(self.player->position, temp->position)), 10);
		if(temp->movement.y < -10)
		{
			[temp jump];
		}
		if(arc4random() % 10 == 0)
		{
			GLKVector2 dig = GLKVector2Add(GLKVector2Add(temp->position, GLKVector2Normalize(temp->movement)), GLKVector2Make(0, -4));
			//NSLog(@"(%f %f) + (%f, %f) -> (%f, %f)", temp->position.x, temp->position.y, temp->movement.x, temp->movement.y, dig.x, dig.y);
			[self.env deleteRadius:5 x:dig.x y:dig.y];
			dig = GLKVector2Add(dig, GLKVector2Make(0, 8));
			[self.env deleteRadius:5 x:dig.x y:dig.y];
		}
		if(![((Zombie *) temp) update: time projection:self.projectionMatrix])
		{
			[self.particles addBloodWithPosition:temp->position power:150 colorType:BloodColorRed count:8];
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, self.player->position)) < 140);
			
			[temp respawn:newPosition];
			zombieKills++;
			self.killDisplay.str = [[NSString alloc] initWithFormat:@"kills %d", zombieKills];
			//[indexes addIndex: i];
		}
		else if(GLKVector2Length(GLKVector2Subtract(self.player->position, temp->position)) < 4)
		{
			self.player->health -= 2;
			[self.particles addBloodWithPosition:self.player->position power:75 colorType:BloodColorRed];
		}
		[[self.zombieTracker objectAtIndex:i] updateTrackee: temp->position center: self.player->position];
	}
	//[self.enemies removeObjectsAtIndexes: indexes];
	//[self.zombieTracker removeObjectsAtIndexes: indexes];
	
	[currentGun update:time];
	
	//generate a new bullet
	if(self.controls.look->toggle)
	{
		[currentGun shootAtPosition:self.player->position direction:self.controls.look->velocity];
	}
	
	
	return YES;
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
	glClearColor(0.3, 0.3, 0.3, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.env render];
	
	[self.player render];
	
	[self.enemies makeObjectsPerformSelector:@selector(render)];
	[self.particles render];
	[self.zombieTracker makeObjectsPerformSelector:@selector(render)];
	[self.killDisplay render];
	
	 [self.controls render];
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
