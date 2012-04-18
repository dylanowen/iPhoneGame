//
//  NinjaRope.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NinjaRope.h"

#import "Globals.h"

#import "GameModel.h"
#import "Environment.h"

#import "EffectLoader.h"

#import "Player.h"

enum
{
	waiting,
	shooting,
	stuck
};

@interface NinjaRope()
{
	GameModel *game;
	Environment *environment;
	
	Player *player;
	
	int state;
	
	int precision;
	
	GLKBaseEffect *effect;
	
	GLKVector2 velocity;
	GLKVector2 position;
	int stepX;
	int stepY;
	
	int widthBound;
	int heightBound;
}

@end

@implementation NinjaRope

- (id)initWithModel:(GameModel *) model player:(Player *) user
{
	self = [super init];
	if(self)
	{
		game = model;
		environment = game->environment;
		
		player = user;
		
		precision = 100;
		widthBound = (ENV_WIDTH - 1) * precision;
		heightBound = (ENV_HEIGHT - 1) * precision;
		
		effect = [game.effectLoader getEffectForName:@"NinjaRope"];
		if(effect == nil)
		{
			effect = [game.effectLoader addEffectForName:@"NinjaRope"];
		}
		
		state = waiting;
		playerMovement = GLKVector2Make(0.0f, 0.0f);
		
		return self;
	}
	return nil;
}

- (void)shoot:(GLKVector2) direction
{
	state = shooting;
	velocity = GLKVector2MultiplyScalar(direction, 200);
	position = player->position;
	playerMovement = GLKVector2Make(0.0f, 0.0f);
	int movement[2] = {(int) (direction.x * precision), (int) (direction.y * precision)};
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
	}
	else {
		stepX = precision;
		stepY = 0;
	}
}

- (void)cancel
{
	state = waiting;
	playerMovement = GLKVector2Make(0.0f, 0.0f);
}

- (void)update
{
	if(state == shooting)
	{
		bool start = YES;
		int intI, intJ, lastI, lastJ, i, j;
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
				if(intI < 1 || intJ < 0 || intI >= ENV_WIDTH || intJ >= ENV_HEIGHT || [environment getDirtX:intI Y:intJ])
				{
					state = stuck;
					position.x = ((float) i) / precision;
					position.y = ((float) j) / precision;
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
		
		position.x += ((float) movement[0]) / precision;
		position.y += ((float) movement[1]) / precision;
	}
	else if(state == stuck)
	{
		playerMovement = GLKVector2Subtract(position, player->position);
		float force = GLKVector2Length(playerMovement) - 40.0f;
		if(force > 0)
		{
			playerMovement = GLKVector2MultiplyScalar(GLKVector2Normalize(playerMovement), force * ROPE_FORCE);
		}
		else
		{
			playerMovement = GLKVector2Make(0.0f, 0.0f);
		}
	}
}

- (void)render
{
	if(state != waiting)
	{
		effect.transform.projectionMatrix = game->dynamicProjection;
	
		[effect prepareToDraw];
	
		float vertices2[] = {
			player->position.x, player->position.y,
			position.x, position.y,
			position.x + 1, position.y + 1,
		};
	
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices2);
	
		glDrawArrays(GL_TRIANGLES, 0, 3);
	
		glDisableVertexAttribArray(GLKVertexAttribPosition);
	}
}

@end
