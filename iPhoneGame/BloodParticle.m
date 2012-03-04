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

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc
{
	self = [super init];
	if(self)
	{
		position[0] = posit.x;
		position[1] = posit.y;
		velocity = veloc;
		
		float temp = ((float) (arc4random() % 20)) / 100;
		
		color[0] = ((float) (arc4random() % 60)) / 100 + .3f;
		color[1] = temp;
		color[2] = temp;
		color[3] = 1.0f;
		
		positionAttribute = model->bloodPositionAttribute;
		colorAttribute = model->bloodColorAttribute;
		env = model.game.env;
		
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
		if(movement.x == 0.0f)
		{
			stepY = fabs(movement.y) / movement.y;
		}
		else if(movement.y == 0.0f)
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
		stepX *= 2.0f;
		stepY *= 2.0f;
		
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
				if(intI < 0 || intJ < 0 || intI >= ENV_WIDTH || intJ >= ENV_HEIGHT)
				{
					return NO;
				}	
				if(env->dirt[intI][intJ])
				{
					//if(!start)
					//{
					//	position[0] = i - stepX;
					//	position[1] = j - stepY;
					//}
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
	
	position[0] += movement.x;
	position[1] += movement.y;
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
