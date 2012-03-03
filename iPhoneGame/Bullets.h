//
//  Bullets.h
//  iPhoneGame
//
//  Created by Lion User on 02/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Bullets : NSObject
{
@public
	GLuint positionAttribute;
}

@property (nonatomic, strong) GameModel *game;

- (id)initWithModel:(GameModel *) game;

- (void)addBulletWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius;
- (void)updateWithLastUpdate:(float) time;
- (void)render;

@end
