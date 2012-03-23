//
//  VAOLoader.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface VAOLoader : NSObject

- (id) init;

- (GLuint)addVAOForName:(NSString *) name;
- (GLuint)getVAOForName:(NSString *) name;

@end
