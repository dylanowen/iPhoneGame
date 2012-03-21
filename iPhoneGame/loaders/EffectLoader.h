//
//  EffectLoader.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

//basically a NSMutableDictionary wrapper with nicer names and it loads its own stuff on startup

@interface EffectLoader : NSObject

- (id) init;

- (GLKBaseEffect *)addEffectForName:(NSString *) name;
- (GLKBaseEffect *)getEffectForName:(NSString *) name;

@end
