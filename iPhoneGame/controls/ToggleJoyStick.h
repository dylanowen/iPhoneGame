//
//  ToggleJoyStick.h
//  iPhoneGame
//
//  Created by Lion User on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

enum
{
	nothing,
	up,
	upToggle
};

@interface ToggleJoyStick : JoyStick
{
@public
	bool toggle;
	int state;
@protected
	float toggleBounds;
	
	
}

- (id)initWithCenter:(GLKVector2) posit region:(unsigned) regionR toggleBounds:(float) toggleB model:(GameModel *) game;

@end
