//
//  Environment.h
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameConstants.h"

#define MAX_DELETE_RADIUS 200

@class GameModel;

@interface Environment : NSObject
{
@public
	bool dirt[ENV_WIDTH][ENV_HEIGHT];
}

@property (nonatomic) int width;
@property (nonatomic) int height;

- (id)initWithModel:(GameModel *) game;

- (void)deleteRadius:(int) radius x:(int) x y:(int) y;

- (void)changeColor:(float[4]) newColor x:(int) x y:(int) y;

- (void)render;

@end
