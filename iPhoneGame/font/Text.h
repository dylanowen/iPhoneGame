//
//  Text.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Text : NSObject

@property (strong, nonatomic) NSString *str;

- (id)initWithPosition:(GLKVector2) posit text:(NSString *)text;
- (void)render;

@end
