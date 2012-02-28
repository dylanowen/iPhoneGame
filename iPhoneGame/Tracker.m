//
//  Tracker.m
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tracker.h"

@interface Tracker()
{
	float vertices[14];
	int width, height;
	float widthD2, heightD2;
	
	GLKVector2 scale;
	
	GLKVector4 color;
	
	bool hide;
}

@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation Tracker

@synthesize effect = _effect;

- (id)initWithScale:(GLKVector2) scle width:(int) w height:(int) h red:(float) red green:(float) green blue:(float) blue
{
	self = [super init];
	if(self)
	{
		self.effect = [[GLKBaseEffect alloc] init];
		color = GLKVector4Make(red, green, blue, 0.8f);
		scale = scle;
		width = w;
		height = h;
		widthD2 = ((float) w / 2) - (8 * scale.x);
		heightD2 = ((float) h / 2) - (8 * scale.y);
		
		hide = true;
		
		
		vertices[0] = 8;
		vertices[1] = 0;
		
		vertices[2] = 2;
		vertices[3] = -6;
		vertices[4] = 2;
		vertices[5] = -3;
		vertices[6] = -8;
		vertices[7] = -3;
		
		vertices[8] = -8;
		vertices[9] = 3;
		vertices[10] = 2;
		vertices[11] = 3;
		vertices[12] = 2;
		vertices[13] = 6;
		
		self.effect.useConstantColor = YES;
		self.effect.constantColor = color;
		
		self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, width, height, 0, 1, -1);
		
		return self;
	}
	return nil;
}

- (void)updateTrackee:(GLKVector2) trackee center:(GLKVector2) center
{
	GLKVector2 temp = GLKVector2Subtract(trackee, center);
	if(temp.x < widthD2 && temp.x > -widthD2 && temp.y < heightD2 && temp.y > -heightD2)
	{
		hide = true;
	}
	else
	{
		hide = false;
		
		float x = (heightD2 * temp.x) / temp.y;
		float y = (widthD2 * temp.y) / temp.x;
		if(temp.x < 0 && temp.y < 0)
		{
			x = -x;
			y = -y;
		}
		else if(temp.x < 0)
		{
			y = -y;
		}
		else if(temp.y < 0)
		{
			x = -x;
		}
		
		if(x > widthD2)
		{
			x = widthD2;
		}
		else if(x < -widthD2)
		{
			x = -widthD2;
		}
		if(y > heightD2)
		{
			y = heightD2;
		}
		else if(y < -heightD2)
		{
			y = -heightD2;
		}
		NSLog(@"wh(%d, %d) (%f, %f) => (%f, %f)", width, height, temp.x, temp.y, x, y);
		GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(x + widthD2 + (8 * scale.x), y + heightD2 + (8 * scale.y), 0.0f), GLKMatrix4MakeScale(scale.x, scale.y, 1));
		//GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(x + widthD2, y + heightD2, 0.0f);
		self.effect.transform.modelviewMatrix = GLKMatrix4Rotate(modelViewMatrix, atan2f(temp.y, temp.x), 0, 0, 1);
	}
}

- (void)render
{
	if(!hide)
	{
		[self.effect prepareToDraw];
	
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
		glDrawArrays(GL_TRIANGLE_FAN, 0, 7);

		glDisableVertexAttribArray(GLKVertexAttribPosition);
	}	
}

@end
