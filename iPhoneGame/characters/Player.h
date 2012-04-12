//
//  Player.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@class NinjaRope;

@interface Player : Character
{
@public
	bool shootGun;
	GLKVector2 lookGun;
	
	GLKVector2 lookRope;
	
	NinjaRope *ninjaRope;
}

- (id)initWithPosition:(GLKVector2) posit;

@end
