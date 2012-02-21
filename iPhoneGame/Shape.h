//
//  Shape.h
//  iPhoneGame
//
//  Created by Laura Cantu on 2/19/12.
//  Copyright (c) 2012 University of California, Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Shape : NSObject
{
	NSMutableData *vertexData;
	NSMutableData *vertexColorData;
	
	GLKVector4 color;
	GLKVector2 position;
}

@property (readonly) int numVertices;
@property (readonly) GLKVector2 *vertices;

@property (strong, nonatomic) GameModel *gameModel;

- (id)initWithGameModel:(GameModel *) model;

- (void)render;

@end
