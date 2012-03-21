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
		jumpHeight = 65;
		
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
	if(arc4random() % 70 == 0 && health < 100)
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
		characterTextureBuffer = [texture getFrameBuffer:1];
	}
	else
	{
		characterTextureBuffer = [texture getFrameBuffer:0];
	}
	[super renderCharacter];
}

@end
