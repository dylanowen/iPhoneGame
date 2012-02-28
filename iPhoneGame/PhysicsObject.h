//
//  PhysicsObject.h
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define GRAVITY 5.8f

@class GameModel;

@interface PhysicsObject : NSObject
{
@public
	CGPoint position;
	GLKVector2 velocity;
}

@property (nonatomic, strong) GameModel *game;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (id)initWithModel:(GameModel *) model position:(CGPoint) posit;
- (bool)updateAndKeep:(float) time;
- (void)render;

@end
