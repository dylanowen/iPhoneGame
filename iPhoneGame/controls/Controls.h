//
//  Controls.h
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JoyStick.h"
#import "ToggleJoyStick.h"
#import "Button.h"

@class GameModel;

@interface Controls : NSObject
{
@public
	ToggleJoyStick *shootRope;
}

@property (strong, nonatomic) JoyStick *move;
@property (strong, nonatomic) ToggleJoyStick *look;

- (id)initWithModel: (GameModel *) game;
- (void)render;

- (void)touchesBegan:(NSSet *)touches;
- (void)touchesMoved:(NSSet *)touches;
- (void)touchesEnded:(NSSet *)touches;
- (void)touchesCancelled:(NSSet *)touches;

@end
