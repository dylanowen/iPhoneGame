//
//  VAOLoader.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VAOLoader.h"

@interface VAOLoader()
{
	NSMutableDictionary *vaos;
}
@end

@implementation VAOLoader

- (id)init
{
	self = [super init];
	if(self)
	{
		vaos = [[NSMutableDictionary alloc] init];
		return self;
	}
	return nil;
}

- (GLuint)addVAOForName:(NSString *) name
{
	NSNumber *temp = [vaos objectForKey:name];
	if(temp == nil)
	{
		GLuint number;
		glGenVertexArraysOES(1, &number);
		temp = [NSNumber numberWithUnsignedInt:number];
		[vaos setObject:temp forKey:name];
	}
	return [temp unsignedIntValue];
}

- (GLuint)getVAOForName:(NSString *) name
{
	NSNumber *temp = [vaos objectForKey:name];
	if(temp != nil)
	{
		return [temp unsignedIntValue];
	}
	return 0;
}

@end
