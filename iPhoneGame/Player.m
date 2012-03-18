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
	
}

- (GLKMatrix4)centerView;

@end

@implementation Player

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit texture:(GLKTextureInfo *) text
{
	self = [super initWithModel:model position:posit texture:text];
	if(self)
	{
		health = 100;
		return self;
	}
	return nil;
}

- (GLKMatrix4)update:(float) time
{
	[super update:time];
	projection = [self centerView];
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
