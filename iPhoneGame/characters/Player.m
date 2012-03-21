//
//  Player.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "TextureLoader.h"

@interface Player()
{
	bool switchTexture;
}

- (GLKMatrix4)centerView;

@end

@implementation Player


- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		texture = [model.textureLoader getTextureDescription:@"character.png"];

		switchTexture = false;
		characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		jumpHeight = 65;
		
		return self;
	}
	return nil;
}

- (GLKMatrix4)update:(float) time
{
	[super update:time];
	projection = [self centerView];
	if(animateTimer >= .25f)
	{
		currentFrame++;
		if(currentFrame > 3)
		{
			currentFrame = 0;
		}
		if(health < 500)
		{
			characterTextureBuffer = [texture getFrameBuffer:currentFrame + 4];
		}
		else
		{
			characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		}
		animateTimer = 0;
	}
	//slight healing
	if(arc4random() % 70 == 0 && health < 100)
	{
		health += 5;
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

@end
