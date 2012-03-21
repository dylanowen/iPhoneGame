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
	int switchTexture;
}
@end

@implementation Zombie

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		texture = [model.textureLoader getTextureDescription:@"zombie.png"];
		
		switchTexture = 40;
		jumpHeight = 45;
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time projection:(GLKMatrix4) matrix
{
	[self update: time];
	projection = matrix;
	if(switchTexture <= 0)
	{
		switchTexture = arc4random() % 40 + 20;
	}
	switchTexture--;
	return health > 0;
}

- (void)renderCharacter
{
	if(switchTexture <= 20)
	{
		characterTextureBuffer = [texture getFrameBuffer:0];
	}
	else
	{
		characterTextureBuffer = [texture getFrameBuffer:1];
	}
	[super renderCharacter];
}

@end
