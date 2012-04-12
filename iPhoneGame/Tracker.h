//
//  Tracker.h
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Tracker : NSObject

- (id)initWithModel:(GameModel *) model red:(float) red green:(float) green blue:(float) blue;

- (void)updateTrackee:(GLKVector2) trackee center:(GLKVector2) center;
- (void)render;

@end
