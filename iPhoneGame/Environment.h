//
//  Environment.h
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject
{

	float *color;

}

@property (nonatomic) int width;
@property (nonatomic) int height;

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint colorBuffer;

@property (nonatomic) unsigned vertexBufferSize;
@property (nonatomic) unsigned colorBufferSize;

- (id)initWithWidth:(int) width height:(int) height;

- (void)delete:(CGPoint) point radius:(unsigned) radius;

- (void)render;

@end
