//
//  Player.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#import "GameConstants.h"

@interface Player()
{
	bool switchTexture;
}

- (GLKMatrix4)centerView;

@end

@implementation Player

static GLuint staticPlayerTextureBuffer1 = 0;
static GLuint staticPlayerTextureBuffer2 = 0;

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit texture:(GLKTextureInfo *) text
{
	self = [super initWithModel:model position:posit texture:text];
	if(self)
	{
		if(staticPlayerTextureBuffer1 == 0)
		{
			float vertices[] = {
				.5, 0,
				.5, 1,
				0, 1,
				0, 0
			};
			glGenBuffers(1, &staticPlayerTextureBuffer1);
			glBindBuffer(GL_ARRAY_BUFFER, staticPlayerTextureBuffer1);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		if(staticPlayerTextureBuffer2 == 0)
		{
			float vertices[] = {
				1, 0,
				1, 1,
				.5, 1,
				.5, 0
			};
			glGenBuffers(1, &staticPlayerTextureBuffer2);
			glBindBuffer(GL_ARRAY_BUFFER, staticPlayerTextureBuffer2);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		switchTexture = false;
		health = 100;
		
		return self;
	}
	return nil;
}

- (GLKMatrix4)update:(float) time
{
	[super update:time];
	projection = [self centerView];
	if(health < 40)
	{
		switchTexture = true;
	}
	else
	{
		switchTexture = false;
	}
	//slight healing
	if(arc4random() % 50 == 0 && health < 100)
	{
		health += 1;
	}
	return projection;
}

- (GLKMatrix4)centerView
{
	float left, top, right, bottom;
	left = position.x - (VIEW_WIDTH / 2);
	top = position.y - (VIEW_HEIGHT / 2);
	right = left + VIEW_WIDTH;
	bottom = top + VIEW_HEIGHT;
	return GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
}

- (void)renderCharacter
{
	if(switchTexture)
	{
		characterTextureBuffer = staticPlayerTextureBuffer2;
	}
	else
	{
		characterTextureBuffer = staticPlayerTextureBuffer1;
	}
	[super renderCharacter];
}

@end
