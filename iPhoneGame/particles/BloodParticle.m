//
//  BloodParticle.m
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodParticle.h"

#import "Globals.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "Particles.h"
#import "Environment.h"

@interface BloodParticle()
{
	GLKVector2 velocity;
	GLuint positionAttribute;
	GLuint colorAttribute;
	
	Environment *env;
	
	float position[2];
	float color[4];
}

@end

@implementation BloodParticle

- (id)initWithParticles:(Particles *) particles position:(GLKVector2) posit velocity:(GLKVector2) veloc colorType:(int) colorType
{
	self = [super init];
	if(self)
	{
		position[0] = posit.x;
		position[1] = posit.y;
		velocity = veloc;
		
		float temp = ((float) (arc4random() % 20)) / 100;
		
		color[0] = temp;
		color[1] = temp;
		color[2] = temp;
		color[3] = 1.0f;
		
		if(colorType == BloodColorRed || colorType == BloodColorGreen || colorType == BloodColorBlue)
		{
			color[colorType] = ((float) (arc4random() % 60)) / 100 + .3f;
		}
		else if(colorType == BloodColorWhite)
		{
			color[0] += .7f;
			color[1] += .7f;
			color[2] += .7f;
		}
		
		positionAttribute = particles->bloodPositionAttribute;
		colorAttribute = particles->bloodColorAttribute;
		env = particles->game->environment;
		
		return self;
	}
	return nil;
}

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc
{
	return [self initWithParticles:model position:posit velocity:veloc colorType:BloodColorRed];
}

- (bool)updateAndKeep
{
	int precision = 100;
	int intI, intJ, lastI, lastJ, i, j, stepX = 0, stepY = 0;
	velocity.y += GRAVITY;
	int movement[2] = {(int) (velocity.x * timeSinceUpdate * precision), (int) (velocity.y * timeSinceUpdate * precision)};
	
	if(movement[0] != 0 || movement[1] != 0)
	{
		if(movement[0] == 0)
		{
			stepY = (movement[1] < 0)?-precision:precision;
		}
		else if(movement[1] == 0)
		{
			stepX = (movement[0] < 0)?-precision:precision;
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
				if(intI < 0 || intJ < 0 || intI >= ENV_WIDTH || intJ >= ENV_HEIGHT)
				{
					return NO;
				}	
				if([env checkDirtX:intI Y:intJ])
				{
					[env changeColor:color x:intI y:intJ];
					return NO;
				}
			}
			lastI = intI;
			lastJ = intJ;
			i += stepX;
			j += stepY;
		}
	}
	
	position[0] += ((float) movement[0]) / precision;
	position[1] += ((float) movement[1]) / precision;
	return YES;
}



- (void)render
{
	//assume blood shaders have already been called
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, position);
	
	glEnableVertexAttribArray(colorAttribute);
	glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, color);
	
	glDrawArrays(GL_POINTS, 0, 1);
	
	glDisableVertexAttribArray(colorAttribute);
	glDisableVertexAttribArray(positionAttribute);
}

@end
