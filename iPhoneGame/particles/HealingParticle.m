//
//  HealingParticle.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealingParticle.h"

#import "Globals.h"

#import "Particles.h"

@interface HealingParticle()
{
	GLuint positionAttribute;
	GLuint timeAttribute;
	
	float position[2];
	
	float time;
	float endTime;
}

@end

@implementation HealingParticle

- (id)initWithParticles:(Particles *) particles position:(GLKVector2) posit
{
	self = [super init];
	if(self)
	{
		position[0] = posit.x;
		position[1] = posit.y;
		
		positionAttribute = particles->healthParticleInitialPosition;
		timeAttribute = particles->healthParticleTime;
		
		time = (float) (arc4random() % 100) / 70;
		
		return self;
	}
	return nil;
}

- (bool)updateAndKeep
{
	time += timeSinceUpdate;
	if(time >= 1.5f)
	{
		return NO;
	}
	return YES;
}

- (void)render
{
	//assume health particle shaders have already been called
	glEnableVertexAttribArray(positionAttribute);
	glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, GL_FALSE, 0, position);
	
	glEnableVertexAttribArray(timeAttribute);
	glVertexAttribPointer(timeAttribute, 1, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) &time);
	
	glDrawArrays(GL_POINTS, 0, 1);
	
	glDisableVertexAttribArray(timeAttribute);
	glDisableVertexAttribArray(positionAttribute);
}

@end
