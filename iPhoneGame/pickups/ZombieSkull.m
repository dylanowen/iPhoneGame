//
//  ZombieSkull.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZombieSkull.h"

#import "Globals.h"
#import "GameModel.h"
#import "BufferLoader.h"
#import "TextureLoader.h"

@implementation ZombieSkull

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		vertexBuffer = [game.bufferLoader getBufferForName:@"Item"];
		if(vertexBuffer == 0)
		{
			float vertices[] = {
				4, -4,
				4, 4,
				-4, 4,
				-4, -4
			};
			vertexBuffer = [game.bufferLoader addBufferForName:@"Item"];
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		pickupDistance = 10;
		
		texture = [game.textureLoader getTextureDescription:@"zombie_skull.png"];
		
		textureBuffer = [texture getFrameBuffer:0];
		
		return self;
	}
	return nil;
}

@end
