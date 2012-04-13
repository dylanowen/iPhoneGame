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
	float widthD2, heightD2;
	
	GLKBaseEffect *effect;
	
	GLuint vertex;
	
	GLKMatrix4 modelView;
	
	GLuint vertexBuffer;
	
	bool hide;
}
@end

@implementation Tracker

- (id)initWithModel:(GameModel *) model red:(float) red green:(float) green blue:(float) blue
{
	self = [super init];
	if(self)
	{
		widthD2 = ((float) STATIC_VIEW_WIDTH / 2) - 8.0f;
		heightD2 = ((float) STATIC_VIEW_HEIGHT / 2) - 8.0f;
		
		hide = true;
		
		effect = [model.effectLoader getEffectForName:[[NSString alloc] initWithFormat:@"Tracker%.2f%.2f%.2f", red, green, blue, nil]];
		if(effect == nil)
		{
			effect = [model.effectLoader addEffectForName:[[NSString alloc] initWithFormat:@"Tracker%.2f%.2f%.2f", red, green, blue, nil]];
			effect.useConstantColor = YES;
			effect.constantColor = GLKVector4Make(red, green, blue, 0.8f);
			effect.transform.projectionMatrix = model->staticProjection;
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
	if(temp.x > DYNAMIC_VIEW_WIDTH / 2 || temp.x < -DYNAMIC_VIEW_WIDTH / 2 || temp.y > DYNAMIC_VIEW_HEIGHT / 2 || temp.y < -DYNAMIC_VIEW_HEIGHT / 2)
	{
		hide = false;
		
		float x = heightD2 * temp.x / temp.y;
		float y = widthD2 * temp.y / temp.x;
		if(temp.x < 0)
		{
			y = -y;
		}
		if(temp.y < 0)
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

		modelView = GLKMatrix4Rotate(GLKMatrix4MakeTranslation(x + STATIC_VIEW_WIDTH / 2, y + STATIC_VIEW_HEIGHT / 2, 0.0f), atan2f(temp.y, temp.x), 0, 0, 1);
	}
	else
	{
		hide = true;
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
