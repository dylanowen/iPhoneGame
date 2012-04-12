//
//  Text.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Text : NSObject

- (id)initWithModel:(GameModel *)model position:(GLKVector2) posit text:(NSString *)text;

- (void)setText:(NSString *) text;

- (void)render;

@end
