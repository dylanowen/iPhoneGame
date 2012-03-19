//
//  ZombieCharacter.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

@interface Zombie()
{
	int switchTexture;
}
@end

@implementation Zombie

static GLuint staticZombieTextureBuffer1 = 0;
static GLuint staticZombieTextureBuffer2 = 0;

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit texture:(GLKTextureInfo *) text
{
	self = [super initWithModel:model position:posit texture:text];
	if(self)
	{
		if(staticZombieTextureBuffer1 == 0)
		{
			float vertices[] = {
				.5, 0,
				.5, 1,
				0, 1,
				0, 0
			};
			glGenBuffers(1, &staticZombieTextureBuffer1);
			glBindBuffer(GL_ARRAY_BUFFER, staticZombieTextureBuffer1);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		if(staticZombieTextureBuffer2 == 0)
		{
			float vertices[] = {
				1, 0,
				1, 1,
				.5, 1,
				.5, 0
			};
			glGenBuffers(1, &staticZombieTextureBuffer2);
			glBindBuffer(GL_ARRAY_BUFFER, staticZombieTextureBuffer2);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
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
		characterTextureBuffer = staticZombieTextureBuffer1;
	}
	else
	{
		characterTextureBuffer = staticZombieTextureBuffer2;
	}
	[super renderCharacter];
}

@end
