//
//  ToggleJoyStick.h
//  iPhoneGame
//
//  Created by Lion User on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

@interface ToggleJoyStick : JoyStick
{
@public
	bool toggle;
@protected
	float toggleBounds;
}

- (id)initWithModel:(GameModel *) model center:(GLKVector2) posit region:(unsigned) regionR grabRegion:(unsigned) grabRegion joyRadius:(float) joyLen toggleBounds:(float) toggleB;

@end
