//
//  GameModel.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIEW_WIDTH 160
#define VIEW_HEIGHT 240

#define ENV_WIDTH 400
#define ENV_HEIGHT 600

@class Environment;

@interface GameModel : NSObject
{
@public
	GLKMatrix4 projectionMatrix;

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
