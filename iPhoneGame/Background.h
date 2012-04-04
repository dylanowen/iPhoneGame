//
//  Background.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameModel;

@interface Background : NSObject

- (id)initWithModel:(GameModel *) game;

- (void)render;

@end
