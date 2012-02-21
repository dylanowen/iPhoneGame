//
//  DirtPixel.h
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Shape.h"

@interface DirtPixel : Shape
{
@public
	float width, height;
}

- (id)initWithGameModel:(GameModel *) model position:(GLKVector2) pos;

@end
