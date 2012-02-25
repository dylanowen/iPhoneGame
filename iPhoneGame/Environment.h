//
//  Environment.h
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_DELETE_RADIUS 50

@class GameModel;
@class GLProgram;

@interface Environment : NSObject
{
	
}

@property (nonatomic) int width;
@property (nonatomic) int height;

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint colorBuffer;

- (id)initWithModel:(GameModel *) game;

- (void)deleteRadius:(int) radius x:(int) x y:(int) y;

- (void)render;

@end
