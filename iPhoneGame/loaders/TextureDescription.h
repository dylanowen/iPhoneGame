//
//  TextureDescription.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

//basically a fancy struct so I can store NSObjects inside of it without ARC complaining

@interface TextureDescription : NSObject
{
@public
	GLKTextureInfo *texture;
	NSMutableArray *frameBuffers;
}

- (id)initWithTexture:(GLKTextureInfo *) text frameBuffers:(NSMutableArray *) frame;

- (GLuint)getName;
- (GLuint)getFrameBuffer:(int) index;

@end
