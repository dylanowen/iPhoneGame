//
//  GameModel.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIEW_WIDTH 240
#define VIEW_HEIGHT 160

#define ENV_WIDTH 400
#define ENV_HEIGHT 600

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

@class Environment;

@interface GameModel : NSObject
{
@public
	GLuint _program;
	//DirtPixel *dirt[DIRT_WIDTH][DIRT_HEIGHT];
	//GLubyte dirtIndices[WIDTH * HEIGHT * 3];
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (readonly) GLKMatrix4 projectionMatrix;

@property (strong, nonatomic) Environment *env;

- (id)initWithContext:(EAGLContext *) context effect:(GLKBaseEffect *) effect shaders:(GLuint) shaders;
- (void)touchesBegan:(CGPoint) CGPoint;

- (void)update;
- (void)render;

@end
