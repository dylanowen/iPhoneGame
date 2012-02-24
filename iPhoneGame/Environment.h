//
//  Environment.h
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameModel;

@interface Environment : NSObject
{
	
}

@property (nonatomic, strong) GameModel *game;

@property (nonatomic) int width;
@property (nonatomic) int height;

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint colorBuffer;

- (id)initWithModel:(GameModel *) game;

- (void)delete:(CGPoint) point radius:(unsigned) radius;

- (void)render;

@end
