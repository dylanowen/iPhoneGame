//
//  Item.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

#import "Globals.h"

#import "GameModel.h"
#import "Environment.h"
#import "Player.h"

#import "EffectLoader.h"
#import "TextureDescription.h"

@interface Item()
{

}
@end

@implementation Item

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super init];
	if(self)
	{
		position = posit;
		velocity = GLKVector2Make(0.0f, 0.0f);
		
		game = model;
		env = game->environment;
		player = game->player;
		
		textureEffect = [game.effectLoader getEffectForName:@"TextureEffect"];
		if(textureEffect == nil)
		{
			textureEffect = [game.effectLoader addEffectForName:@"TextureEffect"];
			textureEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
			textureEffect.texture2d0.target = GLKTextureTarget2D;
		}
		
		timer = 0.0f;
		disappearTime = 10.0f;
		pickupDistance = 6;
		precision = 100;
		
		return self;
	}
	return nil;
}

- (bool)updateAndKeep
{
	int x, y, lowX = INT_MIN, lowY = INT_MIN, highX = INT_MAX, highY = INT_MAX, stepX = 0, stepY = 0, intX, intY;
	bool collision;
	
	if(GLKVector2Length(GLKVector2Subtract(position, player->position)) < pickupDistance)
	{
		[self pickedUp];
		return NO;
	}
	
	timer += timeSinceUpdate;
	if(timer > disappearTime)
	{
		return NO;
	}
	
	velocity.y += GRAVITY / 5;
	int newPosition[2] = {(int) (velocity.x * timeSinceUpdate * precision), (int) (velocity.y * timeSinceUpdate * precision)};
	//NSLog(@"Movement (%d, %d)", newPosition[0], newPosition[1]);
	
	x = (int) (position.x * (float) precision);
	y = (int) (position.y * (float) precision);
	
	if(newPosition[0] == 0 && newPosition[1] == 0)
	{
		//nothing has moved so don't do anything
		return YES;
	}
	else if(newPosition[0] == 0)
	{
		stepY = (newPosition[1] < 0)?-precision:precision;
		
		lowY = y - abs(newPosition[1]);
		highY = y + abs(newPosition[1]);
	}
	else if(newPosition[1] == 0)
	{
		stepX = (newPosition[0] < 0)?-precision:precision;
		
		lowX = x - abs(newPosition[0]);
		highX = x + abs(newPosition[0]);
	}
	else
	{
		if(abs(newPosition[0]) > abs(newPosition[1]))
		{
			stepX = (newPosition[0] < 0)?-precision:precision;
			stepY = (newPosition[1] < 0)?-abs((long long) newPosition[1] * precision / newPosition[0]):abs((long long) newPosition[1] * precision / newPosition[0]);
		}
		else if(abs(newPosition[0]) < abs(newPosition[1]))
		{
			stepX = (newPosition[0] < 0)?-abs((long long) newPosition[0] * precision / newPosition[1]):abs((long long) newPosition[0] * precision / newPosition[1]);
			stepY = (newPosition[1] < 0)?-precision:precision;
		}
		else
		{
			stepX = (newPosition[0] < 0)?-precision:precision;
			stepY = (newPosition[1] < 0)?-precision:precision;
		}
		
		lowX = x - abs(newPosition[0]);
		highX = x + abs(newPosition[0]);
		lowY = y - abs(newPosition[1]);
		highY = y + abs(newPosition[1]);
	}
	stepX *= 2;
	stepY *= 2;
	
	while(x <= highX && x >= lowX && y <= highY && y >= lowY)
	{
		x += stepX;
		y += stepY;
		intX = x / precision;
		intY = y / precision;
		
		collision = false;
		if(env->dirt[intX][intY] || intX < 1 || intY < 1 || intX > ENV_WIDTH || intY > ENV_HEIGHT)
		{
			collision = true;
		}
		
		if(stepX != 0 && collision)
		{
			x = x - stepX;
			velocity.x = -velocity.x / 10;
			break;
		}
		if(stepY != 0 && collision)
		{
			y = y - stepY;
			//NSLog(@"%f", velocity.y);
			velocity.y = -velocity.y / 5;
			//NSLog(@"%f", velocity.y);
			break;
		}
	}
	
	position.x = (float) x / precision;
	position.y = (float) y / precision;
	
	return YES;
}

- (void)pickedUp
{
	[game itemPickedUp:self];
}

- (void)render
{
	textureEffect.texture2d0.name = [texture getName];
	textureEffect.transform.projectionMatrix = game->dynamicProjection;
	textureEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);
	
	[textureEffect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, textureBuffer);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
