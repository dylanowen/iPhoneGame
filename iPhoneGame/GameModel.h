//
//  GameModel.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "GameConstants.h"
#import "Controls.h"

@class Environment;
@class Controls;

@interface GameModel : NSObject
{
@public
	GLKMatrix4 projectionMatrix;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (readonly) GLKMatrix4 projectionMatrix;

@property (strong, nonatomic) Environment *env;
@property (strong, nonatomic) Controls *controls;

- (id)initWithView:(UIView *) view;

- (void)update;
- (void)render;

@end
