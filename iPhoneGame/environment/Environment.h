//
//  Environment.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameModel;

@interface Environment : NSObject
{
@protected
	GameModel *game;
}

- (id)initWithModel:(GameModel *) model;

- (void)deleteRadius:(int) radius x:(int) x y:(int) y;
- (void)restoreRadius:(int) radius x:(int) x y:(int) y;

- (void)editRect:(bool) del leftX:(int) x topY:(int) y width:(int) width height:(int) height;

- (void)changeColor:(float[4]) newColor x:(int) x y:(int) y;

- (bool)checkDirtX:(unsigned) x Y:(unsigned) y;

- (void)render:(float) x;

@end
