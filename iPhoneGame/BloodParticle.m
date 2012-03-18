//
//  BloodParticle.m
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodParticle.h"

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

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc colorType:(int) colorType
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
		
		color[colorType] = ((float) (arc4random() % 60)) / 100 + .3f;
		
		positionAttribute = model->bloodPositionAttribute;
		colorAttribute = model->bloodColorAttribute;
		env = model.game.env;
		
		return self;
	}
	return nil;
}

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc
{
	return [self initWithParticles:model position:posit velocity:veloc colorType:0];
}

- (bool)updateAndKeep:(float) time
{
	bool start = YES;
	int precision = 1000000;
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
				if(env->dirt[intI][intJ])
				{
					[env changeColor:color x:intI y:intJ];
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
