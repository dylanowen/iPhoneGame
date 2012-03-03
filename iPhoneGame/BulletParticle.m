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
#import "Bullets.h"
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

- (id)initWithBulletsModel:(Bullets *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius
{
	self = [super init];
	if(self)
	{
		position[0] = posit.x;
		position[1] = posit.y;
		velocity = veloc;
		
		positionAttribute = model->positionAttribute;
		env = model.game.env;
		
		destructionRadius = radius;
		
		return self;
	}
	return nil;
}

- (bool)updateAndKeep:(float) time
{
	bool start = YES;
	int intI, intJ, lastI = -1000, lastJ = -1000;
	float i, j, stepX = 1.0f, stepY = 1.0f;
	velocity.y += GRAVITY;
	GLKVector2 movement = GLKVector2MultiplyScalar(velocity, time);
	
	//NSLog(@"%f, %f", movement.x, movement.y);
	
	if(movement.x != 0.0f || movement.y != 0.0f)
	{
		//NSLog(@"movement: %f, %f time: %f", movement.x, movement.y, time);
		if(movement.x == 0)
		{
			stepY = fabs(movement.y) / movement.y;
		}
		else if(movement.y == 0)
		{
			stepX = fabs(movement.x) / movement.x;
		}
		else if(fabs(movement.x) > fabs(movement.y))
		{
			stepY = movement.y / movement.x;
		}
		else if(fabs(movement.x) < fabs(movement.y))
		{
			stepX = movement.x / movement.y;
		}
		else
		{
			stepX = fabs(movement.x) / movement.x;
			stepY = fabs(movement.y) / movement.y;
		}
		stepX *= 3;
		stepY *= 3;
		
		i = position[0];
		j = position[1];
		
		float lowX = i - fabs(movement.x);
		float highX = i + fabs(movement.x);
		float lowY = j - fabs(movement.y);
		float highY = j + fabs(movement.y);
		
		while(i <= highX && i >= lowX && j <= highY && j >= lowY)
		{			
			intI = floor(i);
			intJ = floor(j);
			if(intI != lastI || intJ != lastJ)
			{
				if(intI <= 1 && intJ <= 1)
				{
					position[0] = 1.0f;
					position[1] = 1.0f;
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
					return NO;
				}
				else if(intI <= 1)
				{
					position[0] = 1.0f;
					position[1] = j;
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
					return NO;
				}
				else if(intJ <= 1)
				{
					position[0] = i;
					position[1] = 1.0f;
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
					return NO;
				}
				else if(intI >= ENV_WIDTH - 1 && intJ >= ENV_HEIGHT - 1)
				{
					position[0] = (float) (ENV_WIDTH - 1);
					position[1] = (float) (ENV_HEIGHT - 1);
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
					return NO;
				}
				else if(intI >= ENV_WIDTH - 1)
				{
					position[0] = (float) (ENV_WIDTH - 1);
					position[1] = j;
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
					return NO;
				}
				else if(intJ >= ENV_HEIGHT - 1)
				{
					position[0] = i;
					position[1] = (float) (ENV_HEIGHT - 1);
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
					return NO;
				}
			
			
				if(env->dirt[intI][intJ])
				{
					if(!start)
					{
						position[0] = i - stepX;
						position[1] = j - stepY;
					}
					[env deleteRadius:destructionRadius x:(int) position[0] y:(int) position[1]];
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
	
	position[0] += movement.x;
	position[1] += movement.y;
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
