//
//  ToggleJoyStick.h
//  iPhoneGame
//
//  Created by Lion User on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

#define TOGGLE_BOUNDS 15

@interface ToggleJoyStick : JoyStick
{
@public
	bool toggle;
}

- (id)initWithCenter:(GLKVector2) posit effect:(GLKBaseEffect *)effe;

@end
