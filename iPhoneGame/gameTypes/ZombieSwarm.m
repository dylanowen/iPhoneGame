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

- (id)initWithView:(GameViewController *) gameView
{
	self = [super initWithView:gameView];
	if(self)
	{
		zombies = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ZOMBIES];
		zombieTracker = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ZOMBIES];
		for(unsigned i = 0; i < NUMBER_OF_ZOMBIES; i++)
		{
			GLKVector2 newPosition;
			//keep the enemies a certain distance from the player
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, player->position)) < 80);
			[zombies addObject:[[Zombie alloc] initWithModel:self position:newPosition]];
			[zombieTracker addObject:[[Tracker alloc] initWithModel:self red: 0.0f green: 0.35f blue: 0.0f]];
			[environment deleteRadius:20 x:newPosition.x y:newPosition.y];
		}
		
		[availableWeapons addObject:[[MachineGun alloc] initWithParticles:particles]];
		[availableWeapons addObject:[[ShotGun alloc] initWithParticles:particles]];
		[availableWeapons addObject:[[Sniper alloc] initWithParticles:particles]];
		[availableWeapons addObject:[[BouncyMachineGun alloc] initWithParticles:particles]];
		[availableWeapons addObject:[[BouncyShotGun alloc] initWithParticles:particles]];
		
		player->currentGun = [availableWeapons objectAtIndex:0];
		
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
		killDisplay = [[Text alloc] initWithModel:self position:GLKVector2Make(5, 5) text:@"kills 0"];
		
		return self;
	}
	return nil;
}

- (bool)update
{
	//do all the main stuff of the game
	if(player.health <= 0)
	{
		HighScore *temp = [HighScore sharedManager];
		temp.score = self.zombieKills;
		return NO;
	}
	
	[super update];
	
	[particles update];
	
	for(unsigned i = 0; i < [zombies count]; i++)
	{
		Character *temp = [zombies objectAtIndex:i];
		if(![((Zombie *) temp) update])
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
			
			do
			{
				newPosition = GLKVector2Make(arc4random() % (ENV_WIDTH - 20) + 10, arc4random() % (ENV_HEIGHT - 20) + 10);
			}while(GLKVector2Length(GLKVector2Subtract(newPosition, player->position)) < 140);
			
			[environment restoreRadius:40 x:newPosition.x y:newPosition.y];
		}
		[[zombieTracker objectAtIndex:i] updateTrackee: temp->position center: player->position];
	}
	
	[pickups update];

	
	return YES;
}

- (bool)checkBulletHit:(BulletParticle *) bullet
{
	if([player checkBullet:bullet])
	{
		return YES;
	}
	
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
	[player render];
	[particles render];
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
	[killDisplay setText:[[NSString alloc] initWithFormat:@"kills %d", zombieKills]];
}

@end
