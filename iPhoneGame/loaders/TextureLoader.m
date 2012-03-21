//
//  TextureLoader.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 
 make texturedescription its own class
*/

#import "TextureLoader.h"

@interface TextureLoader()
{
	NSMutableDictionary *textures;
	NSMutableDictionary *vertexBuffers;
}

- (NSMutableArray *)getTextureFrameBuffers:(int) numberFrames;

@end

@implementation TextureLoader

- (id) init
{
	self = [super init];
	if(self)
	{
		textures = [[NSMutableDictionary alloc] init];
		vertexBuffers = [[NSMutableDictionary alloc] init];
		
		[self addTexture:@"zombie.png" frames:8];
		[self addTexture:@"character.png" frames:8];
		[self addTexture:@"circleRed.png" frames:1];
		[self addTexture:@"circle.png" frames:1];
		[self addTexture:@"font.png" frames:40];
		[self addTexture:@"jump_button.png" frames:2];
		
		return self;
	}
	return nil;
}

- (void)dealloc
{
	for(NSMutableArray *buffers in vertexBuffers)
	{
		for(NSNumber *number in buffers)
		{
			GLuint temp = [number unsignedIntValue];
			glDeleteBuffers(1, &temp);
		}
	}
}

- (void)addTexture:(NSString *) textureFile frames:(int) frames
{
	if([textures objectForKey:textureFile] == nil)
	{
		NSError *error;
		GLKTextureInfo *texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:textureFile].CGImage options:nil error:&error];
		if(error)
		{
			NSLog(@"Error loading texture from image: %@", error);
			return;
		}
		[textures setObject:[[TextureDescription alloc] initWithTexture:texture frameBuffers:[self getTextureFrameBuffers:frames]] forKey:textureFile];
		//NSLog(@"Loaded texture %@", textureFile);
	}
}

- (TextureDescription *)getTextureDescription:(NSString *) textureFile
{
	return [textures objectForKey:textureFile];
}

- (NSMutableArray *)getTextureFrameBuffers:(int) numberFrames
{
	NSNumber *index = [NSNumber numberWithInt:numberFrames];
	NSMutableArray *returnValue = [vertexBuffers objectForKey:index];
	if(returnValue == nil)
	{
		returnValue = [[NSMutableArray alloc] initWithCapacity:numberFrames];
		
		GLuint tempBuffer;
		float offset = 1.0f / numberFrames;
		for(unsigned i = 0; i < numberFrames; i++)
		{
			tempBuffer = 0;
			float vertices[] = {
				offset * (i + 1), 0.0f,
				offset * (i + 1), 1.0f,
				offset * i, 1.0f,
				offset * i, 0.0f
			};
			glGenBuffers(1, &tempBuffer);
			glBindBuffer(GL_ARRAY_BUFFER, tempBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			[returnValue addObject:[NSNumber numberWithUnsignedInt:tempBuffer]];
		}
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		
		[vertexBuffers setObject:returnValue forKey:index];
	}
	return returnValue;
}

@end
