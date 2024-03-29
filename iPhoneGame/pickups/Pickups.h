//
//  Pickups.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Pickups : NSObject

- (id)initWithModel:(GameModel *) model;
- (void)addZombieSkullWithPosition:(GLKVector2) posit;
- (void)addHealthWithPosition:(GLKVector2) posit;

- (void)update;
- (void)render;

@end
