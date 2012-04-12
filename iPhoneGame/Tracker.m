//
//  Tracker.m
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tracker.h"

#import "Globals.h"
#import "GameModel.h"
#import "EffectLoader.h"
#import "BufferLoader.h"

@interface Tracker()
{
	int width, height;
	float widthD2, heightD2;
	
	GLKBaseEffect *effect;
	
	GLuint vertex;
	
	GLKVector2 scale;
	
	GLKVector4 color;
	
	GLKMatrix4 modelView;
	
	GLuint vertexBuffer;
	
	bool hide;
}
@end

@implementation Tracker

- (id)initWithModel:(GameModel *) model scale:(GLKVector2) scle width:(int) w height:(int) h red:(float) red green:(float) green blue:(float) blue;
{
	self = [super init];
	if(self)
	{
		color = GLKVector4Make(red, green, blue, 0.8f);
		scale = scle;
		width = w;
		height = h;
		widthD2 = ((float) w / 2) - (8 * scale.x);
		heightD2 = ((float) h / 2) - (8 * scale.y);
		
		hide = true;
		
		effect = [model.effectLoader getEffectForName:[[NSString alloc] initWithFormat:@"Tracker%.2f%.2f%.2f", red, green, blue, nil]];
		if(effect == nil)
		{
			effect = [model.effectLoader addEffectForName:[[NSString alloc] initWithFormat:@"Tracker%.2f%.2f%.2f", red, green, blue, nil]];
			effect.useConstantColor = YES;
			effect.constantColor = color;
			effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, width, height, 0, 1, -1);
		}
		
		vertexBuffer = [model.bufferLoader getBufferForName:@"Tracker"];
		if(vertexBuffer == 0)
		{
			float vertices[] = {
				8, 0,
				2, -6,
				2, -3,
				-8, -3,
				-8, 3,
				2, 3,
				2, 6
			};
			vertexBuffer = [model.bufferLoader addBufferForName:@"Tracker"];
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		
		
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
		//NSLog(@"wh(%d, %d) (%f, %f) => (%f, %f)", width, height, temp.x, temp.y, x, y);
		modelView = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(x + widthD2 + (8 * scale.x), y + heightD2 + (8 * scale.y), 0.0f), GLKMatrix4MakeScale(scale.x, scale.y, 1));
		//GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(x + widthD2, y + heightD2, 0.0f);
		modelView = GLKMatrix4Rotate(modelView, atan2f(temp.y, temp.x), 0, 0, 1);
	}
}

- (void)render
{
	if(!hide)
	{
		effect.transform.modelviewMatrix = modelView;
		[effect prepareToDraw];
	
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
		glDrawArrays(GL_TRIANGLE_FAN, 0, 7);

		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glDisableVertexAttribArray(GLKVertexAttribPosition);
	}	
}

@end
