//
//  DirtPixel.m
//  iPhoneGame
//
//  Created by Lion User on 20/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirtPixel.h"

@implementation DirtPixel

- (id)initWithGameModel:(GameModel *) model position:(GLKVector2) pos
{
	self = [super initWithGameModel: model];
	if(self)
	{
		position = pos;
		return self;
	}
	return nil;
}

-(int)numVertices
{
	return 4;
}

-(void)updateVertices {
  self.vertices[0] = GLKVector2Make( width/2.0, -height/2.0);
  self.vertices[1] = GLKVector2Make( width/2.0, height/2.0);
  self.vertices[2] = GLKVector2Make(-width/2.0, height/2.0);
  self.vertices[3] = GLKVector2Make(-width/2.0, -height/2.0);
}

-(float)width {
  return width;
}

-(void)setWidth:(float)_width {
  width = _width;
  [self updateVertices];
}

-(float)height {
  return height;
}

-(void)setHeight:(float)_height {
  height = _height;
  [self updateVertices];
}

@end
