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

#define COLLISION_HEIGHT 14
#define COLLISION_WIDTH 16

@interface Character()
{
	GameModel *game;
	Environment *env;
	
	GLKBaseEffect *effect;
	GLKTextureInfo *characterTexture;
	
	int precision;
	float characterCenter[2];
	
	int CVLeft[COLLISION_HEIGHT][2];
	int CVRight[COLLISION_HEIGHT][2];
	
	int CVTop[COLLISION_WIDTH][2];
	int CVBottom[COLLISION_WIDTH][2];
	
	int CVLeftFF[COLLISION_HEIGHT][2];
	int CVRightFF[COLLISION_HEIGHT][2];
	
	int CVTopFF[COLLISION_WIDTH][2];
	int CVBottomFF[COLLISION_WIDTH][2];
}

- (bool)checkCollisionVertexFF:(unsigned) x y:(unsigned) y;
- (bool) checkCollisionVertex:(unsigned) x y:(unsigned) y;
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
		characterCenter[0] = ((float) CHARACTER_WIDTH / 2);
		characterCenter[1] = ((float) CHARACTER_HEIGHT / 2);
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
	int intI, intJ, lastI, lastJ, i, j, stepX, stepY;
	velocity.y += GRAVITY;
	
	
	
	int movement[2] = {(int) (velocity.x * time * precision), (int) (velocity.y * time * precision)};
	
	//NSLog(@"%f %f -> %d %d", velocity.x, velocity.y, movement[0], movement[1]);
	
		if(movement[0] == 0)
		{
			stepY = (movement[1] < 0)?-precision:precision;
			i = (int) (position.x * (float) precision);
			j = (int) (position.y * (float) precision);
		
			int lowY = j - abs(movement[1]);
			int highY = j + abs(movement[1]);
			while(j < highY && j > lowY)
			{
				j += stepY;
				intJ = ceil((float) j / (float) precision);
				if(intJ != lastJ)
				{
					for(unsigned k = 0; k < COLLISION_WIDTH; k++)
					{
						collisionTop = ([self checkCollisionVertexFF:(i + CVTopFF[k][0]) y:(j + CVTopFF[k][1])])?YES:collisionTop;
						collisionBottom = ([self checkCollisionVertexFF:(i + CVBottomFF[k][0]) y:(j + CVBottomFF[k][1])])?YES:collisionBottom;
					}
					if(collisionTop || collisionBottom)
					{
						if(collisionTop)
						{
							velocity.y = 0.0f;
							position.y = ceilf((float) (j - stepY) / precision);
						}
						else if(collisionBottom)
						{
							velocity.y = 0.0f;
							position.y = ceilf((float) (j - stepY) / precision);
						}
						break;
					}
				}
				lastI = intI;
				lastJ = intJ;
			}
			
			if(!collisionTop && !collisionBottom)
			{
				position.y += ((float) movement[1]) / precision;
			}
		}
		else if(movement[1] == 0)
		{
			stepX = (movement[0] < 0)?-precision:precision;
			i = (int) (position.x * (float) precision);
			j = (int) (position.y * (float) precision);
			
			int lowX = i - abs(movement[0]);
			int highX = i + abs(movement[0]);
			while(i < highX && i > lowX)
			{
				i += stepX;
				intI = ceil((float) i / (float) precision);
				if(intI != lastI)
				{
					if(stepX > 0)
					{
						for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
						{
							collisionRight = ([self checkCollisionVertexFF:(i + CVRightFF[k][0]) y:(j + CVRightFF[k][1])])?YES:collisionRight;
						}
					}
					else if(stepX < 0)
					{
						for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
						{
							collisionLeft = ([self checkCollisionVertexFF:(i + CVLeftFF[k][0]) y:(j + CVLeftFF[k][1])])?YES:collisionLeft;
						}
					}
					for(unsigned k = 0; k < COLLISION_WIDTH; k++)
					{
						collisionTop = ([self checkCollisionVertexFF:(i + CVTopFF[k][0]) y:(j + CVTopFF[k][1])])?YES:collisionTop;
						collisionBottom = ([self checkCollisionVertexFF:(i + CVBottomFF[k][0]) y:(j + CVBottomFF[k][1])])?YES:collisionBottom;
					}
					if(collisionRight || collisionLeft || collisionTop || collisionBottom)
					{
						velocity.x = 0.0f;
						position.x = ceilf((float) (i - stepX) / precision);
						break;
					}
				}
				lastI = intI;
			}
			
			if(!collisionLeft && !collisionRight && !collisionTop && !collisionBottom)
			{
				position.x += ((float) movement[0]) / precision;
			}
		}
		else if(movement[0] != 0 && movement[1] != 0)
		{
			if(abs(movement[0]) > abs(movement[1]))
			{
				stepX = (movement[0] < 0)?-precision:precision;
				stepY = (movement[1] < 0)?-abs((long long) movement[1] * precision / movement[0]):abs((long long) movement[1] * precision / movement[0]);
			}
			else if(abs(movement[0]) < abs(movement[1]))
			{
				stepX = (movement[0] < 0)?-abs((long long) movement[0] * precision / movement[1]):abs((long long) movement[0] * precision / movement[1]);
				stepY = (movement[1] < 0)?-precision:precision;
			}
			else
			{
				stepX = (movement[0] < 0)?-precision:precision;
				stepY = (movement[1] < 0)?-precision:precision;
			}
			
			i = (int) (position.x * (float) precision);
			j = (int) (position.y * (float) precision);
			int lowX = i - abs(movement[0]);
			int highX = i + abs(movement[0]);
			int lowY = j - abs(movement[1]);
			int highY = j + abs(movement[1]);
			
			while(i < highX && i > lowX && j < highY && j > lowY)
			{
				i += stepX;
				j += stepY;
				intI = ceil((float) i / (float) precision);
				intJ = ceil((float) j / (float) precision);
				//NSLog(@"%d -> %.2f / %.2f -> %.2f -> %d ", j, (float) j, (float) precision, ((float) j / (float) precision), intJ);
				if(intI != lastI || intJ != lastJ)
				{
					if(stepX > 0)
					{
						for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
						{
							collisionRight = ([self checkCollisionVertexFF:(i + CVRightFF[k][0]) y:(j + CVRightFF[k][1])])?YES:collisionRight;
						}
					}
					else if(stepX < 0)
					{
						for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
						{
							collisionLeft = ([self checkCollisionVertexFF:(i + CVLeftFF[k][0]) y:(j + CVLeftFF[k][1])])?YES:collisionLeft;
						}
					}
					for(unsigned k = 0; k < COLLISION_WIDTH; k++)
					{
						collisionTop = ([self checkCollisionVertexFF:(i + CVTopFF[k][0]) y:(j + CVTopFF[k][1])])?YES:collisionTop;
						collisionBottom = ([self checkCollisionVertexFF:(i + CVBottomFF[k][0]) y:(j + CVBottomFF[k][1])])?YES:collisionBottom;
					}
					if(collisionLeft || collisionRight || collisionTop || collisionBottom)
					{
						if(collisionTop && collisionBottom)
						{
							unsigned tempI;
							velocity.x = 0.0f;
							for(tempI = 1; tempI < 4; tempI++)
							{
								collisionTop = NO;
								collisionBottom = NO;
								//NSLog(@"checking spot %d", intI - tempI);
								for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
								{
									collisionTop = ([self checkCollisionVertex:(intI + tempI + (CVTop[k][0])) y:(intJ + (CVTop[k][1]))])?YES:collisionTop;
									collisionBottom = ([self checkCollisionVertex:(intI + tempI + (CVBottom[k][0])) y:(intJ + (CVBottom[k][1]))])?YES:collisionBottom;
								}
								if(!collisionTop && !collisionBottom)
								{
									break;
								}
							}
							i = (intI + tempI) * precision;
							intI = ceil((float) i / (float) precision);
							collisionTop = YES;
							collisionBottom = YES;
						}
						else if(collisionTop)
						{
							unsigned tempJ;
							velocity.y = 0.0f;
							for(tempJ = 1; tempJ < 4; tempJ++)
							{
								collisionTop = NO;
								//NSLog(@"checking spot %d", intJ - tempJ);
								for(unsigned k = 0; k < COLLISION_WIDTH; k++)
								{
									collisionTop = ([self checkCollisionVertex:(intI + (CVTop[k][0])) y:(intJ + tempJ + (CVTop[k][1]))])?YES:collisionTop;
								}
								if(!collisionTop)
								{
									break;
								}
							}
							j = (intJ + tempJ) * precision;
							intJ = ceil((float) j / (float) precision);
							collisionTop = YES;
						}
						else if(collisionBottom)
						{
							unsigned tempJ;
							velocity.y = 0.0f;
							for(tempJ = 1; tempJ < 4; tempJ++)
							{
								collisionBottom = NO;
								//NSLog(@"checking spot %d", intJ - tempJ);
								for(unsigned k = 0; k < COLLISION_WIDTH; k++)
								{
									collisionBottom = ([self checkCollisionVertex:(intI + (CVBottom[k][0])) y:(intJ - tempJ + (CVBottom[k][1]))])?YES:collisionBottom;
								}
								if(!collisionBottom)
								{
									break;
								}
							}
							j = (intJ - tempJ) * precision;
							intJ = ceil((float) j / (float) precision);
							collisionBottom = YES;
						}
						if(collisionLeft)
						{
							unsigned tempI;
							velocity.x = 0.0f;
							for(tempI = 1; tempI < 4; tempI++)
							{
								collisionLeft = NO;
								//NSLog(@"checking spot %d", intI - tempI);
								for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
								{
									collisionLeft = ([self checkCollisionVertex:(intI + tempI + CVLeft[k][0]) y:(intJ + CVLeft[k][1])])?YES:collisionLeft;
								}
								if(!collisionLeft)
								{
									break;
								}
							}
							i = (intI + tempI) * precision;
							intI = ceil((float) i / (float) precision);
							collisionLeft = YES;
						}
						else if(collisionRight)
						{
							unsigned tempI;
							velocity.x = 0.0f;
							for(tempI = 1; tempI < 4; tempI++)
							{
								collisionRight = NO;
								//NSLog(@"checking spot %d", intI - tempI);
								for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
								{
									collisionRight = ([self checkCollisionVertex:(intI - tempI + CVRight[k][0]) y:(intJ + CVRight[k][1])])?YES:collisionRight;
								}
								if(!collisionRight)
								{
									break;
								}
							}
							i = (intI - tempI) * precision;
							intI = ceil((float) i / (float) precision);
							collisionRight = YES;
						}
						if((collisionLeft || collisionRight) && (collisionTop || collisionBottom))
						{
							position.x += ((float) i) / precision;
							position.y += ((float) j) / precision;
							break;
						}
					}
				}
				lastI = intI;
				lastJ = intJ;
			}
			
			if(collisionLeft || collisionRight)
			{
				position.x = ((float) i) / precision;
			}
			else
			{
				position.x += ((float) movement[0]) / precision;
			}
			
			if(collisionTop || collisionBottom)
			{
				position.y = ((float) j) / precision;
			}
			else
			{
				position.y += ((float) movement[1]) / precision;
			}
			
		}

	
	effect.transform.projectionMatrix = [self centerView];
	effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - characterCenter[0], position.y - characterCenter[1], 0);
	return effect.transform.projectionMatrix;
}

- (bool) checkCollisionVertex:(unsigned) x y:(unsigned) y
{
	if(x < 1 || y < 1 || x >= (ENV_WIDTH - 1) || y >= (ENV_HEIGHT - 1) || env->dirt[x][y])
	{
		return YES;
	}
	
	return NO;
}

- (bool) checkCollisionVertexFF:(unsigned) x y:(unsigned) y
{
	x = ceil((float) x / (float) precision);
	y = ceil((float) y / (float) precision);
	
	return [self checkCollisionVertex:x y:y];
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
	
	float vertices2[(COLLISION_HEIGHT * 2 + COLLISION_WIDTH * 2) * 3 * 2];
	unsigned vert2Offset = 0;
	for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
	{
		vertices2[vert2Offset++] = (float) CVLeft[k][0];
		vertices2[vert2Offset++] = (float) CVLeft[k][1];
		vertices2[vert2Offset++] = (float) CVLeft[k][0] + 1;
		vertices2[vert2Offset++] = (float) CVLeft[k][1];
		vertices2[vert2Offset++] = (float) CVLeft[k][0];
		vertices2[vert2Offset++] = (float) CVLeft[k][1] + 1;
		vertices2[vert2Offset++] = (float) CVRight[k][0];
		vertices2[vert2Offset++] = (float) CVRight[k][1];
		vertices2[vert2Offset++] = (float) CVRight[k][0] + 1;
		vertices2[vert2Offset++] = (float) CVRight[k][1];
		vertices2[vert2Offset++] = (float) CVRight[k][0];
		vertices2[vert2Offset++] = (float) CVRight[k][1] + 1;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH; k++)
	{
		vertices2[vert2Offset++] = (float) CVTop[k][0];
		vertices2[vert2Offset++] = (float) CVTop[k][1];
		vertices2[vert2Offset++] = (float) CVTop[k][0] + 1;
		vertices2[vert2Offset++] = (float) CVTop[k][1];
		vertices2[vert2Offset++] = (float) CVTop[k][0];
		vertices2[vert2Offset++] = (float) CVTop[k][1] + 1;
		vertices2[vert2Offset++] = (float) CVBottom[k][0];
		vertices2[vert2Offset++] = (float) CVBottom[k][1];
		vertices2[vert2Offset++] = (float) CVBottom[k][0] + 1;
		vertices2[vert2Offset++] = (float) CVBottom[k][1];
		vertices2[vert2Offset++] = (float) CVBottom[k][0];
		vertices2[vert2Offset++] = (float) CVBottom[k][1] + 1;
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
	CVTop[11][1] = CVTopYPos;
	CVTop[12][0] = 12;
	CVTop[12][1] = 1;
	CVTop[13][0] = 13;
	CVTop[13][1] = 1;
	CVTop[14][0] = 14;
	CVTop[14][1] = 2;
	CVTop[15][0] = 15;
	CVTop[15][1] = 3;
	
	int CVBottomYPos = 21;
	CVBottom[0][0] = 0;
	CVBottom[0][1] = 18;
	CVBottom[1][0] = 1;
	CVBottom[1][1] = 19;
	CVBottom[2][0] = 2;
	CVBottom[2][1] = 20;
	CVBottom[3][0] = 3;
	CVBottom[3][1] = 20;
	CVBottom[4][0] = 4;
	CVBottom[4][1] = CVBottomYPos;
	CVBottom[5][0] = 5;
	CVBottom[5][1] = CVBottomYPos;
	CVBottom[6][0] = 6;
	CVBottom[6][1] = CVBottomYPos;
	CVBottom[7][0] = 7;
	CVBottom[7][1] = CVBottomYPos;
	CVBottom[8][0] = 8;
	CVBottom[8][1] = CVBottomYPos;
	CVBottom[9][0] = 9;
	CVBottom[9][1] = CVBottomYPos;
	CVBottom[10][0] = 10;
	CVBottom[10][1] = CVBottomYPos;
	CVBottom[11][0] = 11;
	CVBottom[11][1] = CVBottomYPos;
	CVBottom[12][0] = 12;
	CVBottom[12][1] = 20;
	CVBottom[13][0] = 13;
	CVBottom[13][1] = 20;
	CVBottom[14][0] = 14;
	CVBottom[14][1] = 19;
	CVBottom[15][0] = 15;
	CVBottom[15][1] = 18;
	
	for(unsigned i = 0; i < COLLISION_HEIGHT; i++)
	{
		CVRight[i][0] = 15;
		CVRight[i][1] = i + 4;
		CVLeft[i][0] = 0;
		CVLeft[i][1] = i + 4;
	}
	
	//center the numbers and generate the fake float version
	for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
	{
		CVLeft[k][0] = CVLeft[k][0] - CHARACTER_WIDTH / 2 ;
		CVLeft[k][1] = CVLeft[k][1] - CHARACTER_HEIGHT / 2 ;
		CVRight[k][0] = CVRight[k][0] - CHARACTER_WIDTH / 2 ;
		CVRight[k][1] = CVRight[k][1] - CHARACTER_HEIGHT / 2 ;
		CVLeftFF[k][0] = CVLeft[k][0] * precision;
		CVLeftFF[k][1] = CVLeft[k][1] * precision;
		CVRightFF[k][0] = CVRight[k][0] * precision;
		CVRightFF[k][1] = CVRight[k][1] * precision;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH; k++)
	{
		CVTop[k][0] = CVTop[k][0] - CHARACTER_WIDTH / 2 ;
		CVTop[k][1] = CVTop[k][1] - CHARACTER_HEIGHT / 2 ;
		CVBottom[k][0] = CVBottom[k][0] - CHARACTER_WIDTH / 2 ;
		CVBottom[k][1] = CVBottom[k][1]- CHARACTER_HEIGHT / 2 ;
		CVTopFF[k][0] = CVTop[k][0] * precision;
		CVTopFF[k][1] = CVTop[k][1] * precision;
		CVBottomFF[k][0] = CVBottom[k][0] * precision;
		CVBottomFF[k][1] = CVBottom[k][1] * precision;
	}
}

@end
