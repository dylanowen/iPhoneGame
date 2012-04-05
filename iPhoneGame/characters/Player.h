//
//  Player.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@interface Player : Character
{
@public
	GLKVector2 look;
	bool shoot;
}

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;

@end
