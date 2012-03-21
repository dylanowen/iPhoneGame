//
//  BulletParticleBouncy.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BulletParticleBouncy.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "Particles.h"
#import "Environment.h"

@interface BulletParticleBouncy()
{
	unsigned bounceCount;
	//Particles *particles;
}
@end

@implementation BulletParticleBouncy

- (id)initWithParticles:(Particles *) parts position:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg
{
	self = [super initWithParticles:parts position:posit velocity:veloc destructionRadius:radius damage:dmg];
	if(self)
	{
		//particles = parts;
		bounceCount = 5;
		return self;
	}
	return nil;
}

- (bool)updateAndKeep:(float) time
{
	int intI, intJ, lastI, lastJ, i, j;
	
	if(bounceCount <= 0)
	{
		return NO;
	}
	
	int movement[2] = {(int) (velocity.x * time * precision), (int) (velocity.y * time * precision)};
	
	
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
			if([model checkCharacterHit:self])
			{
				return NO;
			}
			else if(i < precision || j < precision || i >= widthBound || j >= heightBound || env->dirt[intI][intJ])
			{
				position.x = ((float) (i - stepX * destructionRadius)) / precision;
				position.y = ((float) (j - stepY * destructionRadius)) / precision;
				[env deleteRadius:destructionRadius x:lastI y:lastJ];
				velocity = GLKVector2Negate(velocity);
				movement[0] = velocity.x * precision;
				movement[1] = velocity.y * precision;
				[self calculateStep:movement];
				bounceCount--;
				return YES;
			}
		}
		lastI = intI;
		lastJ = intJ;
		i += stepX;
		j += stepY;
	}
	
	position.x += ((float) movement[0]) / precision;
	position.y += ((float) movement[1]) / precision;
	return YES;
}

@end
