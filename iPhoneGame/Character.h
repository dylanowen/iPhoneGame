//
//  Character.h
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Character : NSObject
{
@public
	GLKVector2 position;
	GLKVector2 velocity;
}

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;
- (GLKMatrix4)update:(float) time;
- (void)render;

@end
