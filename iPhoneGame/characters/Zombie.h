//
//  ZombieCharacter.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

@interface Zombie : Character

- (bool)update:(float) time projection:(GLKMatrix4) matrix;

@end
