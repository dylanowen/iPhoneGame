//
//  TextureDescription.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextureDescription.h"

@implementation TextureDescription

- (id)initWithTexture:(GLKTextureInfo *) text frameBuffers:(NSMutableArray *) frame
{
	self = [super init];
	if(self)
	{
		texture = text;
		frameBuffers = frame;
		
		return self;
	}
	return nil;
}

- (GLuint)getName
{
	return texture.name;
}

- (GLuint)getFrameBuffer:(int) index
{
	NSNumber *val = [frameBuffers objectAtIndex:index];
	if(val != nil)
	{
		return [val unsignedIntValue];
	}
	return 0;
}

@end
