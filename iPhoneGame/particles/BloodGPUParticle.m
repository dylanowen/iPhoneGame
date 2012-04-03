//
//  BloodGPU.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BloodGPUParticle.h"

#import "BloodParticle.h"
#import "GameConstants.h"
#import "GameModel.h"
#import "Particles.h"

@interface BloodGPUParticle()
{
	GLKVector2 velocity;
	GLuint positionAttribute;
	GLuint velocityAttribute;
	GLuint colorAttribute;
	GLuint timeAttribute;
	
	float position[2];
	float color[4];
}

@end

@implementation BloodGPUParticle

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
		
		positionAttribute = model->bloodGPUInitialPosition;
		velocityAttribute = model->bloodGPUInitialVelocity;
		colorAttribute = model->bloodGPUColor;
		timeAttribute = model->bloodGPUTime;
		
		return self;
	}
	return nil;
}

- (id)initWithParticles:(Particles *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc
{
	return [self initWithParticles:model position:posit velocity:veloc colorType:BloodColorRed];
}

- (bool)updateAndKeep:(float) dTime
{
	time += dTime;
	if(time >= 2.0f)
	{
		return NO;
	}
	return YES;
}

- (void)render
{
	//assume blood shaders have already been called
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, position);
	
	glEnableVertexAttribArray(velocityAttribute);
	glVertexAttribPointer(velocityAttribute, 2, GL_FLOAT, GL_FALSE, 0, velocity.v);
	
	glEnableVertexAttribArray(colorAttribute);
	glVertexAttribPointer(colorAttribute, 4, GL_FLOAT, GL_FALSE, 0, color);
	
	glEnableVertexAttribArray(timeAttribute);
	glVertexAttribPointer(timeAttribute, 1, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) &time);
	
	glDrawArrays(GL_POINTS, 0, 1);
	
	glDisableVertexAttribArray(timeAttribute);
	glDisableVertexAttribArray(colorAttribute);
	glDisableVertexAttribArray(velocityAttribute);
	glDisableVertexAttribArray(positionAttribute);
}

@end
