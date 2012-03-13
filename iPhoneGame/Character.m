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

#define COLLISION_HEIGHT 18
#define COLLISION_WIDTH_TOP 15
#define COLLISION_WIDTH_BOTTOM 7
#define COLLISION_CORNER 5


@interface Character()
{
	GameModel *game;
	Environment *env;
	
	GLKBaseEffect *effect;
	GLKTextureInfo *characterTexture;
	
	int precision;
	
	int CVLeft[COLLISION_HEIGHT][2];
	int CVRight[COLLISION_HEIGHT][2];
	
	int CVTop[COLLISION_WIDTH_TOP][2];
	int CVBottom[COLLISION_WIDTH_BOTTOM][2];
	
	int CVCornerBL[COLLISION_CORNER][2];
	int CVCornerBR[COLLISION_CORNER][2];
}

-(bool)checkCollisionVertex:(unsigned) x y:(unsigned) y;
- (void)setupCollisionArrays;

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
		
		precision = 1000000;
		[self setupCollisionArrays];
		
		NSError *error;
		characterTexture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"character.png"].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
		}
		
		return self;
	}
	return nil;
}

- (GLKMatrix4)update:(float) time
{
	bool collisionLeft = NO, collisionRight = NO;
	bool collisionTop = NO, collisionBottom = NO;
	bool collisionCornerBL = NO, collisionCornerBR = NO;
	bool start = YES;
	float up = 0;
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
			i += stepX;
			j += stepY;
			intI = i / precision;
			intJ = j / precision;
			if(intI != lastI || intJ != lastJ)
			{
				for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
				{
					collisionLeft = ([self checkCollisionVertex:(i + CVLeft[k][0]) y:(j + CVLeft[k][1])])?YES:collisionLeft;
					collisionRight = ([self checkCollisionVertex:(i + CVRight[k][0]) y:(j + CVRight[k][1])])?YES:collisionRight;
				}
				for(unsigned k = 0; k < COLLISION_WIDTH_TOP; k++)
				{
					collisionTop = ([self checkCollisionVertex:(i + CVTop[k][0]) y:(j + CVTop[k][1])])?YES:collisionTop;
				}
				for(unsigned k = 0; k < COLLISION_WIDTH_BOTTOM; k++)
				{
					collisionBottom = ([self checkCollisionVertex:(i + CVBottom[k][0]) y:(j + CVBottom[k][1])])?YES:collisionBottom;
				}
				for(unsigned k = 0; k < COLLISION_CORNER; k++)
				{
					bool tempBL = [self checkCollisionVertex:(i + CVCornerBL[k][0]) y:(j + CVCornerBL[k][1])];
					bool tempBR = [self checkCollisionVertex:(i + CVCornerBR[k][0]) y:(j + CVCornerBR[k][1])];
					collisionCornerBL = (tempBL)?YES:collisionCornerBL;
					collisionCornerBR = (tempBR)?YES:collisionCornerBR;
					if(tempBL || tempBR)
					{
						up = (float) (CVCornerBL[0][1] - CVCornerBL[k][1]) / precision;
					}
				}
				if(collisionLeft || collisionRight || collisionTop || collisionBottom || collisionCornerBL || collisionCornerBR)
				{
					//NSLog(@"LU=%d RU=%d LL=%d RL=%d T=%d B=%d", collisionLeftUpper, collisionRightUpper, collisionLeftLower, collisionRightLower, collisionTop, collisionBottom);
					if(collisionTop)
					{
						velocity.y = 0.0f;
						position.y = ceilf((float) (j - stepY) / precision);
					}
					else if(collisionBottom)
					{
						velocity.y = 0.0f;
						position.y = floorf((float) (j - stepY) / precision);
					}
					if(collisionLeft || collisionRight)
					{
						velocity.x = 0.0f;
						position.x = (float) ((i - stepX) / precision);
					}
					else if((collisionCornerBL || collisionCornerBR) && collisionBottom)
					{
						if(movement[0] != 0)
						{
							
							position.x += ((float) movement[0]) / precision;
							position.y -= up;
							NSLog(@"up = %f position.y=%f", up, position.y);
						}
					}
					break;
				}
			}
			lastI = intI;
			lastJ = intJ;
			if(start)
			{
				start = NO;
			}
		}
	}
	
	if(!collisionLeft && !collisionRight && !collisionTop && !collisionBottom && !collisionCornerBL && !collisionCornerBR)
	{
		position.x += ((float) movement[0]) / precision;
		position.y += ((float) movement[1]) / precision;
	}
	
	//NSLog(@"%f %f %f", position.y, (float) movement[1] / precision, time);
	
	effect.transform.projectionMatrix = [self centerView];
	effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - ((float) CHARACTER_WIDTH / 2), position.y - ((float) CHARACTER_HEIGHT / 2), 0);
	return effect.transform.projectionMatrix;
}

- (bool) checkCollisionVertex:(unsigned) x y:(unsigned) y
{
	x = floor((float) x / (float) precision);
	y = floor((float) y / (float) precision);
	if(x < 1 && y < 1)
	{
		return YES;
	}
	else if(x < 1)
	{
		return YES;
	}
	else if(y < 1)
	{
		return YES;
	}
	else if(x >= (ENV_WIDTH - 1) && y >= (ENV_HEIGHT - 1))
	{
		return YES;
	}
	else if(x >= (ENV_WIDTH - 1))
	{
		return YES;
	}
	else if(y >= (ENV_HEIGHT - 1))
	{
		return YES;
	}
	if(env->dirt[x][y])
	{
		return YES;
	}
	
	return NO;
}

- (GLKMatrix4)centerView
{
	float left, top, right, bottom;
	left = position.x - (VIEW_WIDTH / 2);
	top = position.y - (VIEW_HEIGHT / 2);
	
	if(left < -10.0f)
	{
		left = -10.0f;
	}
	else if(left + VIEW_WIDTH > ENV_WIDTH + 10)
	{
		left = ENV_WIDTH+ 10 - VIEW_WIDTH;
	}
	if(top < -10.0f)
	{
		top = -10.0f;
	}
	else if(top + VIEW_HEIGHT > ENV_HEIGHT + 10)
	{
		top = ENV_HEIGHT + 10 - VIEW_HEIGHT;
	}
	right = left + VIEW_WIDTH;
	bottom = top + VIEW_HEIGHT;
	return GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)render
{
	float vertices[] = {
		CHARACTER_WIDTH + 1, -1,
		CHARACTER_WIDTH + 1, CHARACTER_HEIGHT + 1,
		-1, CHARACTER_HEIGHT + 1,
		-1, -1
	};
	
	float textureVertices[] = {
		1, 0,
		1, 1,
		0, 1,
		0, 0
	};
	
	//effect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 0.5f);
	
	effect.texture2d0.envMode = GLKTextureEnvModeReplace;
	effect.texture2d0.target = GLKTextureTarget2D;
	effect.texture2d0.name = characterTexture.name;
	
	[effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureVertices);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
	
	float vertices2[(COLLISION_HEIGHT * 2 + COLLISION_WIDTH_TOP + COLLISION_WIDTH_BOTTOM + COLLISION_CORNER * 2) * 3 * 2];
	unsigned vert2Offset = 0;
	for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
	{
		vertices2[vert2Offset++] = (float) CVLeft[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVLeft[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVLeft[k][0] / precision + 1;
		vertices2[vert2Offset++] = (float) CVLeft[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVLeft[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVLeft[k][1] / precision + 1;
		vertices2[vert2Offset++] = (float) CVRight[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVRight[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVRight[k][0] / precision + 1;
		vertices2[vert2Offset++] = (float) CVRight[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVRight[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVRight[k][1] / precision + 1;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH_TOP; k++)
	{
		vertices2[vert2Offset++] = (float) CVTop[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVTop[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVTop[k][0] / precision + 1;
		vertices2[vert2Offset++] = (float) CVTop[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVTop[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVTop[k][1] / precision + 1;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH_BOTTOM; k++)
	{
		vertices2[vert2Offset++] = (float) CVBottom[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVBottom[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVBottom[k][0] / precision + 1;
		vertices2[vert2Offset++] = (float) CVBottom[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVBottom[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVBottom[k][1] / precision + 1;
	}
	for(unsigned k = 0; k < COLLISION_CORNER; k++)
	{
		vertices2[vert2Offset++] = (float) CVCornerBL[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBL[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBL[k][0] / precision + 1;
		vertices2[vert2Offset++] = (float) CVCornerBL[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBL[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBL[k][1] / precision + 1;
		vertices2[vert2Offset++] = (float) CVCornerBR[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBR[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBR[k][0] / precision + 1;
		vertices2[vert2Offset++] = (float) CVCornerBR[k][1] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBR[k][0] / precision;
		vertices2[vert2Offset++] = (float) CVCornerBR[k][1] / precision + 1;
	}
	/*
	for(unsigned k = 0; k < vert2Offset; k += 6)
	{
		NSLog(@"%f %f  %f %f  %f %f", vertices2[k], vertices2[k + 1], vertices2[k + 2], vertices2[k + 3], vertices2[k + 4], vertices2[k + 5]);
	}*/
	GLKBaseEffect *temp = [[GLKBaseEffect alloc] init];
	temp.useConstantColor = YES;
	temp.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.3f);
	temp.transform.projectionMatrix = effect.transform.projectionMatrix;
	temp.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);
	
	[temp prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices2);
	
	glDrawArrays(GL_TRIANGLES, 0, vert2Offset / 2);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

- (void)setupCollisionArrays
{
	//the convention is that ever value is floored before being tested against these vertices
	//therefore if we have 4.5, 0.5 it will collide with CVTop[0]
	//if I was clever this would be read in from a file
	int CVTopYPos = 0;
	
	CVTop[0][0] = 0;
	CVTop[0][1] = 3;
	CVTop[1][0] = 1;
	CVTop[1][1] = 2;
	CVTop[2][0] = 2;
	CVTop[2][1] = 1;
	CVTop[3][0] = 3;
	CVTop[3][1] = 1;
	CVTop[4][0] = 4;
	CVTop[4][1] = CVTopYPos;
	CVTop[5][0] = 5;
	CVTop[5][1] = CVTopYPos;
	CVTop[6][0] = 6;
	CVTop[6][1] = CVTopYPos;
	CVTop[7][0] = 7;
	CVTop[7][1] = CVTopYPos;
	CVTop[8][0] = 8;
	CVTop[8][1] = CVTopYPos;
	CVTop[9][0] = 9;
	CVTop[9][1] = CVTopYPos;
	CVTop[10][0] = 10;
	CVTop[10][1] = CVTopYPos;
	CVTop[11][0] = 11;
	CVTop[11][1] = 1;
	CVTop[12][0] = 12;
	CVTop[12][1] = 1;
	CVTop[13][0] = 13;
	CVTop[13][1] = 2;
	CVTop[14][0] = 14;
	CVTop[14][1] = 3;
	
	int CVBottomYPos = 20;
	CVBottom[0][0] = 4;
	CVBottom[0][1] = CVBottomYPos;
	CVBottom[1][0] = 5;
	CVBottom[1][1] = CVBottomYPos;
	CVBottom[2][0] = 6;
	CVBottom[2][1] = CVBottomYPos;
	CVBottom[3][0] = 7;
	CVBottom[3][1] = CVBottomYPos;
	CVBottom[4][0] = 8;
	CVBottom[4][1] = CVBottomYPos;
	CVBottom[5][0] = 9;
	CVBottom[5][1] = CVBottomYPos;
	CVBottom[6][0] = 10;
	CVBottom[6][1] = CVBottomYPos;
	
	int CVLeftXPos = 0;
	CVLeft[0][0] = CVLeftXPos;
	CVLeft[0][1] = 3;
	CVLeft[1][0] = CVLeftXPos;
	CVLeft[1][1] = 4;
	CVLeft[2][0] = CVLeftXPos;
	CVLeft[2][1] = 5;
	CVLeft[3][0] = CVLeftXPos;
	CVLeft[3][1] = 6;
	CVLeft[4][0] = CVLeftXPos;
	CVLeft[4][1] = 7;
	CVLeft[5][0] = CVLeftXPos;
	CVLeft[5][1] = 8;
	CVLeft[6][0] = CVLeftXPos;
	CVLeft[6][1] = 9;
	CVLeft[7][0] = CVLeftXPos;
	CVLeft[7][1] = 10;
	CVLeft[8][0] = CVLeftXPos;
	CVLeft[8][1] = 11;
	CVLeft[9][0] = CVLeftXPos;
	CVLeft[9][1] = 12;
	CVLeft[10][0] = CVLeftXPos;
	CVLeft[10][1] = 13;
	CVLeft[11][0] = CVLeftXPos;
	CVLeft[11][1] = 14;
	CVLeft[12][0] = CVLeftXPos;
	CVLeft[12][1] = 15;
	CVLeft[13][0] = CVLeftXPos;
	CVLeft[13][1] = 16;
	CVLeft[14][0] = CVLeftXPos;
	CVLeft[14][1] = 17;
	CVLeft[15][0] = 1;
	CVLeft[15][1] = 2;
	CVLeft[16][0] = 2;
	CVLeft[16][1] = 1;
	CVLeft[17][0] = 4;
	CVLeft[17][1] = 0;
	
	int CVRightXPos = 14;
	CVRight[0][0] = CVRightXPos;
	CVRight[0][1] = 3;
	CVRight[1][0] = CVRightXPos;
	CVRight[1][1] = 4;
	CVRight[2][0] = CVRightXPos;
	CVRight[2][1] = 5;
	CVRight[3][0] = CVRightXPos;
	CVRight[3][1] = 6;
	CVRight[4][0] = CVRightXPos;
	CVRight[4][1] = 7;
	CVRight[5][0] = CVRightXPos;
	CVRight[5][1] = 8;
	CVRight[6][0] = CVRightXPos;
	CVRight[6][1] = 9;
	CVRight[7][0] = CVRightXPos;
	CVRight[7][1] = 10;
	CVRight[8][0] = CVRightXPos;
	CVRight[8][1] = 11;
	CVRight[9][0] = CVRightXPos;
	CVRight[9][1] = 12;
	CVRight[10][0] = CVRightXPos;
	CVRight[10][1] = 13;
	CVRight[11][0] = CVRightXPos;
	CVRight[11][1] = 14;
	CVRight[12][0] = CVRightXPos;
	CVRight[12][1] = 15;
	CVRight[13][0] = CVRightXPos;
	CVRight[13][1] = 16;
	CVRight[14][0] = CVRightXPos;
	CVRight[14][1] = 17;
	CVRight[15][0] = 13;
	CVRight[15][1] = 2;
	CVRight[16][0] = 12;
	CVRight[16][1] = 1;
	CVRight[17][0] = 10;
	CVRight[17][1] = 0;
	
	CVCornerBL[0][0] = 4;
	CVCornerBL[0][1] = 20;
	CVCornerBL[1][0] = 3;
	CVCornerBL[1][1] = 19;
	CVCornerBL[2][0] = 2;
	CVCornerBL[2][1] = 19;
	CVCornerBL[3][0] = 1;
	CVCornerBL[3][1] = 18;
	CVCornerBL[4][0] = 0;
	CVCornerBL[4][1] = 17;
	
	CVCornerBR[0][0] = 10;
	CVCornerBR[0][1] = 20;
	CVCornerBR[1][0] = 11;
	CVCornerBR[1][1] = 19;
	CVCornerBR[2][0] = 12;
	CVCornerBR[2][1] = 19;
	CVCornerBR[3][0] = 13;
	CVCornerBR[3][1] = 18;
	CVCornerBR[4][0] = 14;
	CVCornerBR[4][1] = 17;
	
	//convert the numbers to fake floats and center them
	for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
	{
		CVLeft[k][0] = (CVLeft[k][0] * precision) - (CHARACTER_WIDTH * precision) / 2 ;
		CVLeft[k][1] = (CVLeft[k][1] * precision) - (CHARACTER_HEIGHT * precision) / 2 ;
		CVRight[k][0] = (CVRight[k][0] * precision) - (CHARACTER_WIDTH * precision) / 2 ;
		CVRight[k][1] = (CVRight[k][1] * precision) - (CHARACTER_HEIGHT * precision) / 2 ;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH_TOP; k++)
	{
		CVTop[k][0] = (CVTop[k][0] * precision) - (CHARACTER_WIDTH * precision) / 2 ;
		CVTop[k][1] = (CVTop[k][1] * precision) - (CHARACTER_HEIGHT * precision) / 2 ;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH_BOTTOM; k++)
	{
		CVBottom[k][0] = (CVBottom[k][0] * precision) - (CHARACTER_WIDTH * precision) / 2 ;
		CVBottom[k][1] = (CVBottom[k][1] * precision) - (CHARACTER_HEIGHT * precision) / 2 ;
	}
	for(unsigned k = 0; k < COLLISION_CORNER; k++)
	{
		CVCornerBL[k][0] = (CVCornerBL[k][0] * precision) - (CHARACTER_WIDTH * precision) / 2 ;
		CVCornerBL[k][1] = (CVCornerBL[k][1] * precision) - (CHARACTER_HEIGHT * precision) / 2 ;
		CVCornerBR[k][0] = (CVCornerBR[k][0] * precision) - (CHARACTER_WIDTH * precision) / 2 ;
		CVCornerBR[k][1] = (CVCornerBR[k][1] * precision) - (CHARACTER_HEIGHT * precision) / 2 ;
	}
}

@end
