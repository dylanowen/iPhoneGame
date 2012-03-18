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

#define COLLISION_HEIGHT 9
#define COLLISION_WIDTH 3

enum
{
	CVTop = 0,
	CVRight = 1,
	CVBottom = 2,
	CVLeft = 3
};

@interface Character()
{
	GameModel *game;
	Environment *env;
	
	GLKTextureInfo *characterTexture;
	
	GLKVector2 velocity;
	
	
	
	int precision;
	float characterCenter[2];
	
	int CV[4][COLLISION_HEIGHT][2];
	int CVFF[4][COLLISION_HEIGHT][2];
	int CVCount[4];
}

- (void)setupCollisionArrays;
- (BOOL)checkPhys:(int *) x y:(int *) y stepX:(int) stepX stepY:(int) stepY;
- (int)checkCollision:(int) index x:(int) x y:(int) y;

@end

@implementation Character

static GLKBaseEffect static *textureEffect = nil;
static GLKBaseEffect static *healthEffect = nil;
static GLuint characterVertexBuffer = 0;
static GLuint characterTextureBuffer = 0;

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit texture:(GLKTextureInfo *) text
{
	self = [super init];
	if(self)
	{
		game = model;
		env = game.env;
		characterTexture = text;
		
		if(textureEffect == nil)
		{
			textureEffect = [[GLKBaseEffect alloc] init];
			textureEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
			textureEffect.texture2d0.target = GLKTextureTarget2D;
		}
		if(healthEffect == nil)
		{
			healthEffect = [[GLKBaseEffect alloc] init];
			healthEffect.useConstantColor = YES;
			healthEffect.constantColor = GLKVector4Make(0.0f, 0.8f, 0.0f, 0.3f);
		}
		if(characterVertexBuffer == 0)
		{
			float vertices[] = {
				CHARACTER_WIDTH + 1, -1,
				CHARACTER_WIDTH + 1, CHARACTER_HEIGHT + 1,
				-1, CHARACTER_HEIGHT + 1,
				-1, -1
			};
			glGenBuffers(1, &characterVertexBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, characterVertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		if(characterTextureBuffer == 0)
		{
			float textureVertices[] = {
				1, 0,
				1, 1,
				0, 1,
				0, 0
			};
			glGenBuffers(1, &characterTextureBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, characterTextureBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(textureVertices), textureVertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		precision = 100;
		characterCenter[0] = ((float) CHARACTER_WIDTH / 2);
		characterCenter[1] = ((float) CHARACTER_HEIGHT / 2);
		[self setupCollisionArrays];
		
		[self respawn:posit];
		
		return self;
	}
	return nil;
}

- (void)respawn:(GLKVector2) posit
{
	position = posit;
	health = 100;
	velocity = GLKVector2Make(0, 0);
	movement = GLKVector2Make(0, 0);
}

- (void)update:(float) time
{
	int x, y, lowX = INT_MIN, lowY = INT_MIN, highX = INT_MAX, highY = INT_MAX, stepX = 0, stepY = 0;
	
	velocity.y += GRAVITY;
	//NSLog(@"Velocity (%f, %f)", velocity.x, velocity.y);
	int newPosition[2] = {(int) ((velocity.x + movement.x) * time * precision), (int) ((velocity.y + movement.y) * time * precision)};
	//NSLog(@"Movement (%d, %d)", newPosition[0], newPosition[1]);
	
	x = (int) (position.x * (float) precision);
	y = (int) (position.y * (float) precision);
	if(newPosition[0] == 0 && newPosition[1] == 0)
	{
		//nothing has moved so don't do anything
		return;
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
	
	//NSLog(@"Step (%d, %d)", stepX, stepY);
	
	while(x < highX && x > lowX && y < highY && y > lowY)
	{
		x += stepX;
		y += stepY;
		if([self checkPhys:&x y:&y stepX:stepX stepY:stepY])
		{
			break;
		}
	}
	
	position.x = x / precision;
	position.y = y / precision;
}

-(BOOL) checkPhys:(int *) x y:(int *) y stepX:(int) stepX stepY:(int) stepY
{
	BOOL cX = NO, cY = NO;
	int rating[4] = {0, 0, 0, 0};
	int intX = *x / precision;
	int intY = *y / precision;
	
	rating[CVTop] = [self checkCollision:CVTop x:intX y:intY];
	rating[CVRight] = [self checkCollision:CVRight x:intX y:intY];
	rating[CVBottom] = [self checkCollision:CVBottom x:intX y:intY];
	rating[CVLeft] = [self checkCollision:CVLeft x:intX y:intY];
	if(intX < 2)
	{
		rating[CVLeft] += CVCount[CVLeft];
	}
	else if(intX > ENV_WIDTH - 2)
	{
		rating[CVRight] += CVCount[CVRight];
	}
	if(intY < 6)
	{
		rating[CVTop] += CVCount[CVTop];
	}
	else if(intY > ENV_HEIGHT - 7)
	{
		rating[CVBottom] += CVCount[CVBottom];
	}
	
	//NSLog(@"t=%d r=%d b=%d l=%d", rating[CVTop], rating[CVRight], rating[CVBottom], rating[CVLeft]);
	
	if((stepX > 0 && rating[CVRight] > 1) || (stepX < 0 && rating[CVLeft] > 1))
	{
		*x = *x - stepX;
		//intX = *x / precision;
		
		velocity.x = -velocity.x / 5;
		cX = YES;
	}
	
	if((stepY > 0 && rating[CVBottom] > 0) || (stepY < 0 && rating[CVTop] > 0))
	{
		*y = *y - stepY;
		//intX = *y / precision;
		
		velocity.y = -velocity.y / 5;
		cY = YES;
	}

	if((stepX == 0 && cY) || (stepY == 0 && cX) || (cX && cY))
	{
		return YES;
	}
	return NO;
}

-(int) checkCollision:(int) index x:(int) x y:(int) y
{
	int count = 0;
	
	for(unsigned k = 0; k < CVCount[index]; k++)
	{
		count = (env->dirt[x + CV[index][k][0]][y + CV[index][k][1]])?(count + 1):count;
	}
	
	return count;
}

- (BOOL)checkBullet:(GLKVector2) bulletPosition
{
	if(GLKVector2Length(GLKVector2Subtract(bulletPosition, position)) < 6)
	{
		health -= 5;
		return YES;
	}
	return NO;
}

- (void)render
{
	
	
	textureEffect.texture2d0.name = characterTexture.name;
	textureEffect.transform.projectionMatrix = projection;
	textureEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - characterCenter[0], position.y - characterCenter[1], 0);
	
	
	[textureEffect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, characterVertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, characterTextureBuffer);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
	
	healthEffect.transform.modelviewMatrix = textureEffect.transform.modelviewMatrix;
	healthEffect.transform.projectionMatrix = textureEffect.transform.projectionMatrix;
	float vertices2[8] = {
		0, -5,
		0, -2,
		CHARACTER_WIDTH * health / 100, -2,
		CHARACTER_WIDTH * health / 100, -5,
	};
	
	[healthEffect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices2);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);

	 
	//collision vertices debug
	/*
	float vertices2[(COLLISION_HEIGHT * 2 + COLLISION_WIDTH * 2) * 3 * 2];
	unsigned vert2Offset = 0;
	for(unsigned k = 0; k < COLLISION_HEIGHT; k++)
	{
		vertices2[vert2Offset++] = (float) CV[CVLeft][k][0];
		vertices2[vert2Offset++] = (float) CV[CVLeft][k][1];
		vertices2[vert2Offset++] = (float) CV[CVLeft][k][0] + 1;
		vertices2[vert2Offset++] = (float) CV[CVLeft][k][1];
		vertices2[vert2Offset++] = (float) CV[CVLeft][k][0];
		vertices2[vert2Offset++] = (float) CV[CVLeft][k][1] + 1;
		vertices2[vert2Offset++] = (float) CV[CVRight][k][0];
		vertices2[vert2Offset++] = (float) CV[CVRight][k][1];
		vertices2[vert2Offset++] = (float) CV[CVRight][k][0] + 1;
		vertices2[vert2Offset++] = (float) CV[CVRight][k][1];
		vertices2[vert2Offset++] = (float) CV[CVRight][k][0];
		vertices2[vert2Offset++] = (float) CV[CVRight][k][1] + 1;
	}
	for(unsigned k = 0; k < COLLISION_WIDTH; k++)
	{
		vertices2[vert2Offset++] = (float) CV[CVTop][k][0];
		vertices2[vert2Offset++] = (float) CV[CVTop][k][1];
		vertices2[vert2Offset++] = (float) CV[CVTop][k][0] + 1;
		vertices2[vert2Offset++] = (float) CV[CVTop][k][1];
		vertices2[vert2Offset++] = (float) CV[CVTop][k][0];
		vertices2[vert2Offset++] = (float) CV[CVTop][k][1] + 1;
		vertices2[vert2Offset++] = (float) CV[CVBottom][k][0];
		vertices2[vert2Offset++] = (float) CV[CVBottom][k][1];
		vertices2[vert2Offset++] = (float) CV[CVBottom][k][0] + 1;
		vertices2[vert2Offset++] = (float) CV[CVBottom][k][1];
		vertices2[vert2Offset++] = (float) CV[CVBottom][k][0];
		vertices2[vert2Offset++] = (float) CV[CVBottom][k][1] + 1;
	}
	
	for(unsigned k = 0; k < vert2Offset; k += 6)
	{
		NSLog(@"%f %f  %f %f  %f %f", vertices2[k], vertices2[k + 1], vertices2[k + 2], vertices2[k + 3], vertices2[k + 4], vertices2[k + 5]);
	}
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
	 */
}

- (void)setupCollisionArrays
{
	//the convention is that ever value is floored before being tested against these vertices
	//therefore if we have 4.5, 0.5 it will collide with CV[CVTop][0]
	//if I was clever this would be read in from a file
	int tempPos;
	
	CVCount[CVTop] = COLLISION_WIDTH;
	CVCount[CVRight] = COLLISION_HEIGHT;
	CVCount[CVBottom] = COLLISION_WIDTH;
	CVCount[CVLeft] = COLLISION_HEIGHT;
	
	
	tempPos = -1;
	int tempCVleft[COLLISION_HEIGHT][2] = {
		{tempPos, -4},
		{tempPos, -3},
		{tempPos, -2},
		{tempPos, -1},
		{tempPos, 0},
		{tempPos, 1},
		{tempPos, 2},
		{tempPos, 3},
		{tempPos, 4},
	};
	tempPos = 1;
	int tempCVright[COLLISION_HEIGHT][2] = {
		{tempPos, -4},
		{tempPos, -3},
		{tempPos, -2},
		{tempPos, -1},
		{tempPos, 0},
		{tempPos, 1},
		{tempPos, 2},
		{tempPos, 3},
		{tempPos, 4},
	};
	tempPos = -5;
	int tempCVtop[COLLISION_WIDTH][2] = {
		{-1, tempPos},
		{0, tempPos},
		{1, tempPos}
	};
	tempPos = 5;
	int tempCVbottom[COLLISION_WIDTH][2] = {
		{-1, tempPos},
		{0, tempPos},
		{1, tempPos}
	};
	
	for(unsigned i = 0; i < COLLISION_HEIGHT; i++)
	{
		CV[CVLeft][i][0] = tempCVleft[i][0];
		CV[CVLeft][i][1] = tempCVleft[i][1];
		CV[CVRight][i][0] = tempCVright[i][0];
		CV[CVRight][i][1] = tempCVright[i][1];
		CVFF[CVLeft][i][0] = CV[CVLeft][i][0] * precision;
		CVFF[CVLeft][i][1] = CV[CVLeft][i][1] * precision;
		CVFF[CVRight][i][0] = CV[CVRight][i][0] * precision;
		CVFF[CVRight][i][1] = CV[CVRight][i][1] * precision;
	}
	for(unsigned i = 0; i < COLLISION_WIDTH; i++)
	{
		CV[CVTop][i][0] = tempCVtop[i][0];
		CV[CVTop][i][1] = tempCVtop[i][1];
		CV[CVBottom][i][0] = tempCVbottom[i][0];
		CV[CVBottom][i][1] = tempCVbottom[i][1];
		CVFF[CVTop][i][0] = CV[CVTop][i][0] * precision;
		CVFF[CVTop][i][1] = CV[CVTop][i][1] * precision;
		CVFF[CVBottom][i][0] = CV[CVBottom][i][0] * precision;
		CVFF[CVBottom][i][1] = CV[CVBottom][i][1] * precision;
	}
}

@end
