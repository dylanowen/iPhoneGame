//
//  BulletParticle.m
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BulletParticle.h"

#import "Globals.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "Particles.h"
#import "Environment.h"

@implementation BulletParticle

- (id)initWithParticles:(Particles *) particles position:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg
{
	self = [super init];
	if(self)
	{
		position = posit;
		velocity = veloc;
		
		positionAttribute = particles->bulletPositionAttribute;
		game = particles->game;
		env = game->environment;
		
		destructionRadius = radius;
		damage = dmg;
		
		precision = 100;
		widthBound = (ENV_WIDTH - 1) * precision;
		heightBound = (ENV_HEIGHT - 1) * precision;
		
		//something is wrong here?
		int movement[2] = {(int) (velocity.x * precision), (int) (velocity.y * precision)};
		[self calculateStep:movement];
		
		return self;
	}
	return nil;
}

- (void)calculateStep:(int[2]) movement
{
	if(movement[0] != 0 || movement[1] != 0)
	{
		if(movement[0] == 0)
		{
			stepX = 0;
			stepY = (movement[1] < 0)?-precision:precision;
		}
		else if(movement[1] == 0)
		{
			stepX = (movement[0] < 0)?-precision:precision;
			stepY = 0;
		}
		else if(abs(movement[0]) > abs(movement[1]))
		{
			stepX = (movement[0] < 0)?-precision:precision;
			stepY = movement[1] / movement[0];
		}
		else if(abs(movement[0]) < abs(movement[1]))
		{
			stepX = movement[0] / movement[1];
			stepY = (movement[1] < 0)?-precision:precision;
		}
		else
		{
			stepX = (movement[0] < 0)?-precision:precision;
			stepY = (movement[1] < 0)?-precision:precision;
		}
		stepX *= 2;
		stepY *= 2;
	}
	else {
		stepX = precision;
		stepY = 0;
	}
}

- (bool)updateAndKeep
{
	bool start = YES;
	int intI, intJ, lastI, lastJ, i, j;
	int movement[2] = {(int) (velocity.x * timeSinceUpdate * precision), (int) (velocity.y * timeSinceUpdate * precision)};
		
	i = (int) (position.x * precision);
	j = (int) (position.y * precision);
		
	int lowX = i - abs(movement[0]);
	int highX = i + abs(movement[0]);
	int lowY = j - abs(movement[1]);
	int highY = j + abs(movement[1]);
		
	while(i <= highX && i >= lowX && j <= highY && j >= lowY)
	{		
		intI = i / precision;
		intJ = j / precision;
		if(intI != lastI || intJ != lastJ)
		{
			if([game checkBulletHit:self])
			{
				return NO;
			}
			else if(i < precision && j < precision)
			{
				[env deleteRadius:destructionRadius x:1 y:1];
				return NO;
			}
			else if(i < precision)
			{
				[env deleteRadius:destructionRadius x:1 y:intJ];
				return NO;
			}
			else if(j < precision)
			{
				[env deleteRadius:destructionRadius x:intI y:1];
				return NO;
			}
			else if(i >= widthBound && j >= heightBound)
			{
				[env deleteRadius:destructionRadius x:(ENV_WIDTH - 1) y:(ENV_HEIGHT - 1)];
				return NO;
			}
			else if(i >= widthBound)
			{
				[env deleteRadius:destructionRadius x:(ENV_WIDTH - 1) y:intJ];
				return NO;
			}
			else if(j >= heightBound)
			{
				[env deleteRadius:destructionRadius x:intI y:(ENV_HEIGHT - 1)];
				return NO;
			}
		
			if(env->dirt[intI][intJ])
			{
				if(!start)
				{
					intI = lastI;
					intJ = lastJ;
				}
				[env deleteRadius:destructionRadius x:intI y:intJ];
				//[model.particles addBulletWithPosition:GLKVector2Make(position.x, position.y) velocity:GLKVector2Negate(velocity) destructionRadius:destructionRadius];
				return NO;
			}
		}
		lastI = intI;
		lastJ = intJ;
		i += stepX;
		j += stepY;
		if(start)
		{
			start = NO;
		}
	}

	position.x += ((float) movement[0]) / precision;
	position.y += ((float) movement[1]) / precision;
	return YES;
}

- (void)render
{
	//assume bullet shaders have already been called
	//if(abs(model->screenCenter.x - position.x) < (DYNAMIC_VIEW_WIDTH + 1) / 2 && abs(model->screenCenter.y - position.y) < (DYNAMIC_VIEW_HEIGHT + 1))
	//{
		glEnableVertexAttribArray(positionAttribute);
		glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, position.v);
	
		glDrawArrays(GL_POINTS, 0, 1);
	
		glDisableVertexAttribArray(positionAttribute);
	//}
}

@end
