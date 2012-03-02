//
//  BulletParticle.m
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BulletParticle.h"

#import "GameModel.h"
#import "Environment.h"

@implementation BulletParticle

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		velocity = veloc;
		return self;
	}
	return nil;
}

- (bool)updateAndKeep:(float) time
{
	bool collision = NO, start = YES;
	int intI, intJ, lastI, lastJ;
	float i, j, stepX = 1.0f, stepY = 1.0f;
	velocity.y += GRAVITY * time;
	
	//NSLog(@"%f, %f", velocity.x, velocity.y);
	
	if(velocity.x != 0.0f || velocity.y != 0.0f)
	{
		//NSLog(@"velocity: %f, %f", velocity.x, velocity.y);
		if(velocity.x == 0)
		{
			stepY = fabs(velocity.y) / velocity.y;
		}
		else if(velocity.y == 0)
		{
			stepX = fabs(velocity.x) / velocity.x;
		}
		else if(fabs(velocity.x) > fabs(velocity.y))
		{
			stepY = velocity.y / velocity.x;
		}
		else if(fabs(velocity.x) < fabs(velocity.y))
		{
			stepX = velocity.x / velocity.y;
		}
		else
		{
			stepX = fabs(velocity.x) / velocity.x;
			stepY = fabs(velocity.y) / velocity.y;
		}
	
		//NSLog(@"%f, %f", stepX, stepY);
		
		i = position.x;
		j = position.y;
		lastI = -10000;
		lastJ = -10000;
		
		float lowX = i - fabs(velocity.x);
		float highX = i + fabs(velocity.x);
		float lowY = j - fabs(velocity.y);
		float highY = j + fabs(velocity.y);
		
		while(i <= highX && i >= lowX && j <= highY && j >= lowY)
		{			
			intI = floor(i);
			intJ = floor(j);
			if(intI != lastI || intJ != lastJ)
			{
				if(intI <= 1 && intJ <= 1)
				{
					position.x = 1.0f;
					position.y = 1.0f;
					collision = YES;
					break;
				}
				else if(intI <= 1)
				{
					position.x = 1.0f;
					position.y = j;
					collision = YES;
					break;
				}
				else if(intJ <= 1)
				{
					position.x = i;
					position.y = 1.0f;
					collision = YES;
					break;
				}
				else if(intI >= ENV_WIDTH - 1 && intJ >= ENV_HEIGHT - 1)
				{
					position.x = (float) (ENV_WIDTH - 1);
					position.y = (float) (ENV_HEIGHT - 1);
					collision = YES;
					break;
				}
				else if(intI >= ENV_WIDTH - 1)
				{
					position.x = (float) (ENV_WIDTH - 1);
					position.y = j;
					collision = YES;
					break;
				}
				else if(intJ >= ENV_HEIGHT - 1)
				{
					position.x = i;
					position.y = (float) (ENV_HEIGHT - 1);
					collision = YES;
					break;
				}
			
			
				if(self.game.env->dirt[intI][intJ])
				{
					if(!start)
					{
						position.x = i - stepX;
						position.y = j - stepY;
					}
					collision = YES;
					break;
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
	
	if(!collision)
	{
		position.x += velocity.x;
		position.y += velocity.y;
	}
	else
	{
		[self.game.env deleteRadius:10 x:(int) position.x y:(int) position.y];
		velocity.x = 0.0f;
		velocity.y = 0.0f;
		return NO;
	}
	
	self.effect.transform.projectionMatrix = self.game.projectionMatrix;
	self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);
	self.effect.useConstantColor = YES;
	self.effect.constantColor = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);
	return YES;
}

- (void)render
{
	float vertices[] = {
		-0.5, -0.5,
		-0.5, 0.5,
		0.5, -0.5,
		0.5, 0.5
	};

	[self.effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
