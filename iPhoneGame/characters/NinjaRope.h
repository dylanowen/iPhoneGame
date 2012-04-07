//
//  NinjaRope.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class GameModel;
@class Player;

@interface NinjaRope : NSObject
{
@public
	GLKVector2 playerMovement;
}

- (id)initWithModel:(GameModel *) game player:(Player *) self;

- (void)shoot:(GLKVector2) direction;
- (void)cancel;
- (void)update:(float) time;
- (void)render;

@end
