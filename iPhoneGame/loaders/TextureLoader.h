//
//  TextureLoader.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "TextureDescription.h"

@interface TextureLoader : NSObject

- (id) init;

- (void)addTexture:(NSString *) textureFile frames:(int) frames;
- (TextureDescription *)getTextureDescription:(NSString *) textureFile;

@end
