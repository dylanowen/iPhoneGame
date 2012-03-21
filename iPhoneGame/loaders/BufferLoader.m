//
//  BufferLoader.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BufferLoader.h"

@interface BufferLoader()
{
	NSMutableDictionary *buffers;
}

@end

@implementation BufferLoader

- (id)init
{
	self = [super init];
	if(self)
	{
		buffers = [[NSMutableDictionary alloc] init];
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	for(NSNumber *number in buffers)
	{
		GLuint temp = [number unsignedIntValue];
		glDeleteBuffers(1, &temp);
	}
}

- (GLuint)addBufferForName:(NSString *) name
{
	NSNumber *temp = [buffers objectForKey:name];
	if(temp == nil)
	{
		GLuint number;
		glGenBuffers(1, &number);
		temp = [NSNumber numberWithUnsignedInt:number];
		[buffers setObject:temp forKey:name];
		//NSLog(@"Generated buffer: %@", name);
	}
	return [temp unsignedIntValue];
}

- (GLuint)getBufferForName:(NSString *) name
{
	NSNumber *temp = [buffers objectForKey:name];
	if(temp != nil)
	{
		return [temp unsignedIntValue];
	}
	return 0;
}

@end
