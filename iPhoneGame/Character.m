//
//  Character.m
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

#import "GameModel.h"
#import "Environment.h"

@interface Character()
{
	GameModel *game;
	Environment *env;
	
	GLKBaseEffect *effect;
    
    int boundaryOffsetLeft[CHARACTER_HEIGHT][2];
    int boundaryOffsetRight[CHARACTER_HEIGHT][2];
    int boundaryOffsetTop[CHARACTER_WIDTH][2];
    int boundaryOffsetBottom[CHARACTER_WIDTH][2];
    //int boundaryOffsetArray[(CHARACTER_WIDTH + CHARACTER_HEIGHT) * 2][2];
}

@end

@implementation Character

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super init];
	if(self)
	{
		game = model;
		position = posit;
		
		env = game.env;
		
		velocity = GLKVector2Make(0, 0);
		effect = [[GLKBaseEffect alloc] init];
		effect.useConstantColor = YES;
		effect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 0.8f);
        
        int offsetX, offsetY;
        offsetX = -1 * CHARACTER_WIDTH / 2;
        offsetY = -1 * CHARACTER_HEIGHT / 2;
        
        // Setting up the offset array
        for(int i = 0; i < CHARACTER_WIDTH; i++) {
            boundaryOffsetTop[i][0] = boundaryOffsetBottom[i][0] = i - (CHARACTER_WIDTH / 2);
            boundaryOffsetTop[i][1] = -CHARACTER_HEIGHT / 2;
            boundaryOffsetBottom[i][1] = CHARACTER_HEIGHT / 2;
            NSLog(@"top:(%d, %d) bottom:(%d, %d)", boundaryOffsetTop[i][0], boundaryOffsetTop[i][1], boundaryOffsetBottom[i][0], boundaryOffsetBottom[i][1]);
        }
        for(int i = 0; i < CHARACTER_HEIGHT; i++){
            boundaryOffsetLeft[i][0] = -CHARACTER_WIDTH / 2;
            boundaryOffsetRight[i][0] = CHARACTER_WIDTH / 2;
            boundaryOffsetLeft[i][1] = boundaryOffsetRight[i][1] = i - (CHARACTER_HEIGHT / 2);
            NSLog(@"left:(%d, %d) right:(%d, %d)", boundaryOffsetLeft[i][0], boundaryOffsetLeft[i][1], boundaryOffsetRight[i][0], boundaryOffsetRight[i][1]);
        }
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time
{
	bool collision = NO, start = YES;
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
		
		i = position.x;
		j = position.y;
		
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
				if(intI < 1 && intJ < 1)
				{
					position.x = 1.0f;
					position.y = 1.0f;
					collision = YES;
					break;
				}
				else if(intI < 1)
				{
					position.x = 1.0f;
					position.y = j;
					collision = YES;
					break;
				}
				else if(intJ < 1)
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
			
				if(env->dirt[intI][intJ])
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
		position.x += movement.x;
		position.y += movement.y;
	}
	else
	{
		velocity.x = 0.0f;
		velocity.y = 0.0f;
	}
	
	effect.transform.projectionMatrix = game.projectionMatrix;
	effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);
	return YES;
}

- (void)render
{
	float vertices[] = {
		-2.5, -2.5,
		-2.5, 2.5,
		2.5, -2.5,
		2.5, 2.5
	};
	
	effect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 0.8f);
	
	[effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
