//
//  ZombieSwarm.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZombieSwarm.h"

#import "GameConstants.h"

#import "Settings.h"
#import "HighScore.h"

#import "MatrixFunctions.h"

#import "Controls.h"

#import "Background.h"
#import "Environment.h"
#import "Particles.h"
#import "Pickups.h"
#import "Controls.h"

#import "Tracker.h"
#import "Text.h"

#import "Player.h"
#import "Zombie.h"
#import "Weapon.h"

#import "BouncyMachineGun.h"
#import "MachineGun.h"
#import "ShotGun.h"
#import "BouncyShotGun.h"
#import "Sniper.h"

#define NUMBER_OF_ZOMBIES 15

@interface ZombieSwarm()
{
	NSMutableArray *zombies;
	
	NSMutableArray	*zombieTracker;
	
	//Weapon *currentGun;
	
	Text *killDisplay;
}

@end

@implementation ZombieSwarm

@synthesize zombieKills = _zombieKills;

- (id)initWithView:(UIView *) view
{
	self = [super initWithView:view];
	if(self)
	{
		zombies = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ZOMBIES];
		zombieTracker = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ZOMBIES];
		GLKVector2 trackScale = GLKVector2Make(DYNAMIC_VIEW_WIDTH / self.view.bounds.size.width, DYNAMIC_VIEW_HEIGHT / self.view.bounds.size.height);
		for(unsigned i = 0; i < NUMBER_OF_ZOMBIES; i++)
		{
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, player->position)) < 80);
			[zombies addObject:[[Zombie alloc] initWithModel:self position:newPosition]];
			[zombieTracker addObject:[[Tracker alloc] initWithScale: trackScale width: DYNAMIC_VIEW_WIDTH height: DYNAMIC_VIEW_HEIGHT red: 0.0f green: 0.35f blue: 0.0f model:self]];
			[environment deleteRadius:20 x:newPosition.x y:newPosition.y];
		}
		
		/*
		Settings *settings = [Settings sharedManager];
		switch ([settings weapon]) {
			case 1:
            currentGun = [[Sniper alloc] initWithParticles:particles];
            break;
			case 2:
            currentGun = [[MachineGun alloc] initWithParticles:particles];
            break;
			case 3:
            currentGun = [[ShotGun alloc] initWithParticles:particles];
            break;
			case 4:
            currentGun = [[BouncyShotGun alloc] initWithParticles:particles];
            break;
			default:
            currentGun = [[BouncyMachineGun alloc] initWithParticles:particles];
            break;
		}
		 */
		
		_zombieKills = 0;
		killDisplay = [[Text alloc] initWithModel:self text:@"kills 0" position:GLKVector2Make(5, 5)];
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time
{
	//do all the main stuff of the game
	if(player.health <= 0)
	{
		HighScore *temp = [HighScore sharedManager];
		temp.score = self.zombieKills;
		return NO;
	}
	
	[super update:time];
	
	[particles updateWithLastUpdate: time];
	
	for(unsigned i = 0; i < [zombies count]; i++)
	{
		Character *temp = [zombies objectAtIndex:i];
		if(![((Zombie *) temp) update: time])
		{
			[particles addBloodWithPosition:temp->position power:150 colorType:BloodColorRed count:8];
			[pickups addZombieSkullWithPosition:temp->position];
			
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, player->position)) < 140);
			
			[temp respawn:newPosition];
			//[indexes addIndex: i];
		}
		[[zombieTracker objectAtIndex:i] updateTrackee: temp->position center: player->position];
	}
	
	[pickups update:time];

	
	return YES;
}

- (bool)checkBulletHit:(BulletParticle *) bullet
{
	for(unsigned i = 0; i < [zombies count]; i++)
	{
		if([[zombies objectAtIndex:i] checkBullet:bullet])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)itemPickedUp:(Item *) item
{
	self.zombieKills++;
}

- (void)render
{
	glClear(GL_COLOR_BUFFER_BIT);
	
	[background render];
	[environment render: player->position.x];
	[particles render];
	[player render];
	[zombies makeObjectsPerformSelector:@selector(render)];
	[pickups render];
	
	[zombieTracker makeObjectsPerformSelector:@selector(render)];
	[killDisplay render];
	[controls render];
}

- (void)setZombieKills:(int)zombieKills
{
	_zombieKills = zombieKills;
	if(_zombieKills % 5 == 0)
	{
		player.health += 150;
		[particles addHealingEffect:player->position];
	}
	killDisplay.str = [[NSString alloc] initWithFormat:@"kills %d", zombieKills];
}

@end
