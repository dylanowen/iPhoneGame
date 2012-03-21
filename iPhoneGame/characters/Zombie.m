//
//  ZombieCharacter.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

#import "GameModel.h"
#import "TextureLoader.h"

@interface Zombie()
{
	
}
@end

@implementation Zombie

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		texture = [model.textureLoader getTextureDescription:@"zombie.png"];
		characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		jumpHeight = 45;
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time projection:(GLKMatrix4) matrix
{
	[self update: time];
	projection = matrix;
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
	return health > 0;
}

@end
