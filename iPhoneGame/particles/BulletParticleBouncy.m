//
//  BulletParticleBouncy.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BulletParticleBouncy.h"

#import "Globals.h"

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
		bounceCount = 5;
		return self;
	}
	return nil;
}

- (bool)updateAndKeep
{
	int intI, intJ, lastI, lastJ, i, j;
	
	if(bounceCount <= 0)
	{
		return NO;
	}
	
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
			if(i < precision || i >= widthBound)
			{
				position.x = ((float) (i - stepX * destructionRadius)) / precision;
				position.y = ((float) (j - stepY * destructionRadius)) / precision;
				[env deleteRadius:destructionRadius x:intI y:intJ];
				velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, 0.9f));
				movement[0] = velocity.x * precision;
				movement[1] = velocity.y * precision;
				[self calculateStep:movement];
				bounceCount--;
				return YES;
			}
			else if(j < precision || j >= heightBound)
			{
				position.x = ((float) (i - stepX * destructionRadius)) / precision;
				position.y = ((float) (j - stepY * destructionRadius)) / precision;
				[env deleteRadius:destructionRadius x:intI y:intJ];
				velocity = GLKVector2Multiply(velocity, GLKVector2Make(0.9f, -0.9f));
				movement[0] = velocity.x * precision;
				movement[1] = velocity.y * precision;
				[self calculateStep:movement];
				bounceCount--;
				return YES;
			}
			else if([env getDirtX:intI Y:intJ])
			{
				if(stepX == 0)
				{
					velocity = GLKVector2Multiply(velocity, GLKVector2Make(0.9f, -0.9f));
				}
				else if(stepY == 0)
				{
					velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, 0.9f));
				}
				else if(stepX > 0 && stepY > 0)
				{
					//coming from top left
					bool left = [env getDirtX:intI - 1 Y:intJ];
					bool up = [env getDirtX:intI Y:intJ - 1];
					if((left && up) || (!left && !up))
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, -0.9f));
					}
					else if(left)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(0.9f, -0.9f));
					}
					else if(up)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, 0.9f));
					}
					
				}
				else if(stepX > 0 && stepY < 0)
				{
					//coming from bottom left
					bool left = [env getDirtX:intI - 1 Y:intJ];
					bool down = [env getDirtX:intI Y:intJ + 1];
					if((left && down) || (!left && !down))
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, -0.9f));
					}
					else if(left)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(0.9f, -0.9f));
					}
					else if(down)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, 0.9f));
					}
				}
				else if(stepX < 0 && stepY > 0)
				{
					//coming from top right
					bool right = [env getDirtX:intI + 1 Y:intJ];
					bool up = [env getDirtX:intI Y:intJ - 1];
					if((right && up) || (!right && !up))
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, -0.9f));
					}
					else if(right)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(0.9f, -0.9f));
					}
					else if(up)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, 0.9f));
					}
				}
				else
				{
					//coming from bottom right
					bool right = [env getDirtX:intI + 1 Y:intJ];
					bool down = [env getDirtX:intI Y:intJ + 1];
					if((right && down) || (!right && !down))
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, -0.9f));
					}
					else if(right)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(0.9f, -0.9f));
					}
					else if(down)
					{
						velocity = GLKVector2Multiply(velocity, GLKVector2Make(-0.9f, 0.9f));
					}
				}
				[env deleteRadius:destructionRadius x:intI y:intJ];
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
