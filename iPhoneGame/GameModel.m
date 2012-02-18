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
				dirt[i][j].position[0] = i;
				dirt[i][j].position[1] = j;
				dirt[i][j].position[2] = 0;
				
				dirt[i][j].color[0] = 0.0f;
				dirt[i][j].color[1] = 1.0f;
				dirt[i][j].color[2] = 0.0f;
				dirt[i][j].color[3] = 1.0f;
				
				dirtIndices[i * WIDTH + j] = i * WIDTH + j;
			}
		}
		return self;
	}
	return nil;
}

@end
