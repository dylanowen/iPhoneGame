//
//  Player.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@class Weapon;
@class NinjaRope;

@interface Player : Character
{
@public
	bool shootGun;
	GLKVector2 lookGun;
	
	GLKVector2 lookRope;
	
	Weapon *currentGun;
	NinjaRope *ninjaRope;
}

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;

@end
