//
//  HighScores.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScore.h"

static HighScore* highScoreManager = nil;

@implementation HighScore

@synthesize score;

+ (id) sharedManager {
	@synchronized(self) {
		if(highScoreManager == nil)
		{
			highScoreManager = [[self alloc] init];
		}
	}
	return highScoreManager;
}

- (id)init
{
	self = [super init];
	if(self)
	{
		self.score = 0;
		return self;
	}
	return nil;
}

@end
