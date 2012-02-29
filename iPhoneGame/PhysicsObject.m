//
//  PhysicsObject.m
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsObject.h"

@implementation PhysicsObject

@synthesize game = _game;
@synthesize effect = _effect;
@synthesize collisionVertices = _collisionVertices;

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super init];
	if(self)
	{
		self.game = model;
		position = posit;
		
		self.effect = [[GLKBaseEffect alloc] init];
		self.collisionVertices = [[NSMutableArray alloc] init];
		
		return self;
	}
	return nil;
}

- (bool)updateAndKeep:(float) time
{

	return NO;
}

- (void)render{}

@end
