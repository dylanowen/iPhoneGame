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
            //NSLog(@"top:(%d, %d) bottom:(%d, %d)", boundaryOffsetTop[i][0], boundaryOffsetTop[i][1], boundaryOffsetBottom[i][0], boundaryOffsetBottom[i][1]);
        }
        for(int i = 0; i < CHARACTER_HEIGHT; i++){
            boundaryOffsetLeft[i][0] = -CHARACTER_WIDTH / 2;
            boundaryOffsetRight[i][0] = CHARACTER_WIDTH / 2;
            boundaryOffsetLeft[i][1] = boundaryOffsetRight[i][1] = i - (CHARACTER_HEIGHT / 2);
            //NSLog(@"left:(%d, %d) right:(%d, %d)", boundaryOffsetLeft[i][0], boundaryOffsetLeft[i][1], boundaryOffsetRight[i][0], boundaryOffsetRight[i][1]);
        }
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time
{
	bool collision = NO, start = YES;
	int precision = 1000000, widthBound = (ENV_WIDTH - 1) * precision, heightBound = (ENV_HEIGHT - 1) * precision;
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
		//NSLog(@"(%f, %f)", (float) stepX / precision, (float) stepY / precision);
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
				if(i < precision && j < precision)
				{
					position.x = 1.0f;
					position.y = 1.0f;
					collision = YES;
                    break;
				}
				else if(i < precision)
				{
					position.x = 1.0f;
					position.y = ((float) j) / precision;
					collision = YES;
                    break;
				}
				else if(j < precision)
				{
					position.x = ((float) i) / precision;
					position.y = 1.0f;
					collision = YES;
                    break;
				}
				else if(i >= widthBound && j >= heightBound)
				{
					position.x = (float) (ENV_WIDTH - 1);
					position.y = (float) (ENV_HEIGHT - 1);
					collision = YES;
                    break;
				}
				else if(i >= widthBound)
				{
					position.x = (float) (ENV_WIDTH - 1);
					position.y = ((float) j) / precision;
					collision = YES;
                    break;
				}
				else if(j >= heightBound)
				{
					position.x = ((float) i) / precision;
					position.y = (float) (ENV_HEIGHT - 1);
					collision = YES;
                    break;
				}
                
				if(env->dirt[intI][intJ])
				{
					if(!start)
					{
						position.x = ((float) (i - stepX)) / precision;
						position.y = ((float) (j - stepY)) / precision;
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
	
    //NSLog(@"(%f, %f)", position.x, position.y);
    
	if(!collision)
	{
		position.x += ((float) movement[0]) / precision;
		position.y += ((float) movement[1]) / precision;
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
	
	effect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 0.5f);
	
	[effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
    
    float vertices2[] = {0,0,10,10,10,0};
    effect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.3f);
	
	[effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices2);
	
	glDrawArrays(GL_TRIANGLES, 0, 3);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
    
}

@end
