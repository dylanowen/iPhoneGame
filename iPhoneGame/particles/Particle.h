//
//  Particle.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Particle <NSObject>

- (bool)updateAndKeep;
- (void)render;

@end
