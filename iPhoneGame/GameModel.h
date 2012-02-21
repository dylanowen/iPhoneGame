//
//  GameModel.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIEW_WIDTH 200
#define VIEW_HEIGHT 300

@class Environment;

@interface GameModel : NSObject
{
@public
	//DirtPixel *dirt[DIRT_WIDTH][DIRT_HEIGHT];
	//GLubyte dirtIndices[WIDTH * HEIGHT * 3];
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (readonly) GLKMatrix4 projectionMatrix;

@property (strong, nonatomic) Environment *env;

- (id)initWithContext:(EAGLContext *) context effect:(GLKBaseEffect *) effect;
- (void)touchesBegan:(CGPoint) CGPoint;

- (void)update;
- (void)render;

@end
