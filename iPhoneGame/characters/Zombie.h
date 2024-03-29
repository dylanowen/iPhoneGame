//
//  ZombieCharacter.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@class ZombieSwarm;

@interface Zombie : Character

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;

- (bool)update;

@end
