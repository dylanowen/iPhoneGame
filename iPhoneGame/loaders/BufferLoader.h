//
//  BufferLoader.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface BufferLoader : NSObject

- (id) init;

- (GLuint)addBufferForName:(NSString *) name;
- (GLuint)getBufferForName:(NSString *) name;

@end
