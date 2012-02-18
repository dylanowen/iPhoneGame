//
//  GameModel.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#define WIDTH 500
#define HEIGHT 500

typedef struct
{
	float position[3];
	float color[4];
} DirtVertex;

@interface GameModel : NSObject
{
@public
	DirtVertex dirt[WIDTH][HEIGHT];
	GLubyte dirtIndices[WIDTH * HEIGHT];
}

-(id) init;

@end
