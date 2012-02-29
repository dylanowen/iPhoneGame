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
	GLKVector2 position;
	GLKVector2 velocity;
}

@property (nonatomic, strong) NSMutableArray *collisionVertices;
@property (nonatomic, strong) GameModel *game;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;
- (bool)updateAndKeep:(float) time;
- (void)render;

@end
