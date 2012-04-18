//
//  Environment.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"

@implementation Environment

- (id)initWithModel:(GameModel *) model
{
	self = [super init];
	if(self)
	{
		game = model;
		
		return self;
	}
	return nil;
}

- (void)deleteRadius:(int) radius x:(int) x y:(int) y{}
- (void)restoreRadius:(int) radius x:(int) x y:(int) y{}

- (void)editRect:(bool) del leftX:(int) x topY:(int) y width:(int) width height:(int) height{}

- (void)changeColor:(float[4]) newColor x:(int) x y:(int) y{}

- (bool)checkDirtX:(unsigned) x Y:(unsigned) y
{
	return false;
}

- (void)render:(float) x{}

@end
