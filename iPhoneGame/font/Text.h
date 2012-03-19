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

@property (strong, nonatomic) NSString *str;

- (id)initWithModel:(GameModel *) mod text:(NSString *)text position:(GLKVector2) posit;
- (void)render;

@end
