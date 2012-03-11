//
//  BulletParticle.m
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BulletParticle.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "Particles.h"
#import "Environment.h"

@interface BulletParticle()
{
	GLKVector2 velocity;
	GLuint positionAttribute;
	
	Environment *env;
	
	float position[2];
	unsigned destructionRadius;
}

@end

@implementation BulletParticle

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius
{
	self = [super init];
	if(self)
	{
		position[0] = posit.x;
		position[1] = posit.y;
		velocity = veloc;
		
		positionAttribute = model->bulletPositionAttribute;
		env = model.game.env;
		
		destructionRadius = radius;
		
		return self;
	}
	return nil;
}

- (bool)updateAndKeep:(float) time
{
	bool start = YES;
	int precision = 1000000, widthBound = (ENV_WIDTH - 1) * precision, heightBound = (ENV_HEIGHT - 1) * precision;
	int intI, intJ, lastI, lastJ, i, j, stepX = precision, stepY = precision;
	velocity.y += GRAVITY;
	int movement[2] = {(int) (velocity.x * time * precision), (int) (velocity.y * time * precision)};
	
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
		
		i = (int) (position[0] * precision);
		j = (int) (position[1] * precision);
		
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
				if(i < precision && j < precision)
				{
					position[0] = 1.0f;
					position[1] = 1.0f;
					[env deleteRadius:destructionRadius x:1 y:1];
					return NO;
				}
				else if(i < precision)
				{
					position[0] = 1.0f;
					position[1] = ((float) j) / precision;
					[env deleteRadius:destructionRadius x:1 y:intJ];
					return NO;
				}
				else if(j < precision)
				{
					position[0] = ((float) i) / precision;
					position[1] = 1.0f;
					[env deleteRadius:destructionRadius x:intI y:1];
					return NO;
				}
				else if(i >= widthBound && j >= heightBound)
				{
					position[0] = (float) (ENV_WIDTH - 1);
					position[1] = (float) (ENV_HEIGHT - 1);
					[env deleteRadius:destructionRadius x:(ENV_WIDTH - 1) y:(ENV_HEIGHT - 1)];
					return NO;
				}
				else if(i >= widthBound)
				{
					position[0] = (float) (ENV_WIDTH - 1);
					position[1] = ((float) j) / precision;
					[env deleteRadius:destructionRadius x:(ENV_WIDTH - 1) y:intJ];
					return NO;
				}
				else if(j >= heightBound)
				{
					position[0] = ((float) i) / precision;
					position[1] = (float) (ENV_HEIGHT - 1);
					[env deleteRadius:destructionRadius x:intI y:(ENV_HEIGHT - 1)];
					return NO;
				}
			
				if(env->dirt[intI][intJ])
				{
					if(!start)
					{
						position[0] = ((float) (i - stepX)) / precision;
						position[1] = ((float) (j - stepY)) / precision;
                        intI = lastI;
                        intJ = lastJ;
					}
					[env deleteRadius:destructionRadius x:intI y:intJ];
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
	}
	
	position[0] += ((float) movement[0]) / precision;
	position[1] += ((float) movement[1]) / precision;
	return YES;
}

- (void)render
{
	//assume bullet shaders have already been called
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, position);
	
	glDrawArrays(GL_POINTS, 0, 1);
	
	glDisableVertexAttribArray(positionAttribute);
}

@end
