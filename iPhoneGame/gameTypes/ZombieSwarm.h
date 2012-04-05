//
//  ZombieSwarm.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

@class Player;

@interface ZombieSwarm : GameModel

@property (nonatomic) int zombieKills;

- (void)itemPickedUp:(Item *) item;

@end
