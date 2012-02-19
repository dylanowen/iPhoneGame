//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

@interface GameModel()
{
	
	
}


@end

@implementation GameModel

-(id) init
{
	self = [super init];
	if(self)
	{
		for(unsigned i = 0; i < WIDTH; i++)
		{
			for(unsigned j = 0; j < HEIGHT; j++)
			{
				unsigned offset = i * WIDTH + j;
				dirt[offset].position[0] = (float) i;
				dirt[offset].position[1] = (float) j;
				
				dirt[offset].color = GLKVector4Make((float) i / WIDTH, (float) j / HEIGHT, 1, 1.0);
				
				//NSLog(@"%f, %f", (float) i / WIDTH, (float) j / HEIGHT	);
				
				dirtIndices[offset] = offset;
			}
		}
		return self;
	}
	return nil;
}

@end
