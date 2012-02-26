//
//  JoyStick.m
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JoyStick.h"

#import "GameConstants.h"

@interface JoyStick()
{
	CGPoint position;
	
	CGPoint lastTouch;
	CGPoint origin;
	
	CGRect region;
	
	float vertices[8];
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation JoyStick

@synthesize view = _view;
@synthesize effect = _effect;

- (id)initWithCenter:(CGPoint) posit view:(UIView *) view
{
	self = [super init];
	if(self)
	{
		position = origin = posit;
		self.view = view;
		
		self.effect = [[GLKBaseEffect alloc] init];
		
		lastTouch = CGPointMake(-1, -1);
		velocity = GLKVector2Make(0, 0);
		
		region = CGRectMake(position.x - JOY_LENGTH, position.y - JOY_LENGTH, JOY_LENGTH * 2, JOY_LENGTH * 2);
		//NSLog(@"%@ (%f, %f: %f %f)", self, region.origin.x, region.origin.y, region.size.width, region.size.height);
		
		vertices[0] = 0;
		vertices[1] = 0;
		vertices[2] = JOY_LENGTH;
		vertices[3] = 0;
		vertices[4] = 0;
		vertices[5] = JOY_LENGTH;
		vertices[6] = JOY_LENGTH;
		vertices[7] = JOY_LENGTH;
		
		self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.bounds.size.height, self.view.bounds.size.width, 0, 1, -1);
		
		return self;
	}
	return nil;
}

- (bool)touchesBegan:(CGPoint) loci
{
	if(CGRectContainsPoint(region, loci))
	{
		position = lastTouch = loci;
		velocity = GLKVector2Make(position.x - origin.x, position.y - origin.y);
		//NSLog(@"%f, %f", loci.x, loci.y);
		return YES;
	}

	return NO;
}

- (bool)touchesMoved:(CGPoint) loci lastTouch:(CGPoint) last
{
	if(CGPointEqualToPoint(lastTouch, last))
	{
		position = lastTouch = loci;
		velocity = GLKVector2Make(position.x - origin.x, position.y - origin.y);
		return YES;
	}
	return NO;
}

- (void)touchesEnded
{
	position = origin;
	velocity = GLKVector2Make(0, 0);
}

- (void)render
{
	//move the shape to the correct spot
	self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x - JOY_LENGTH_HALF, position.y - JOY_LENGTH_HALF, 0);

	[self.effect prepareToDraw];
	
	float colors[] = {
		1.0, 0.0, 0.0, .6,
		0.0, 0.0, 0.0, .6,
		0.0, 0.0, 0.0, .6,
		0.0, 0.0, 0.0, .6,
	};
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glEnableVertexAttribArray(GLKVertexAttribColor);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribColor);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
