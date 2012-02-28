//
//  Character.m
//  iPhoneGame
//
//  Created by Lion User on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"

#import "GameModel.h"
#import "Environment.h"

@implementation Character

- (bool)updateAndKeep:(float) time
{
	velocity.y += GRAVITY * time;
	if(position.x > ENV_WIDTH || position.y > ENV_HEIGHT || self.game.env->dirt[(int) position.x][(int) position.y])
	{
		velocity.x = 0;
		velocity.y = 0;
	}
	position.x += velocity.x;
	position.y += velocity.y;
	self.effect.transform.projectionMatrix = self.game.projectionMatrix;
	self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);
	self.effect.useConstantColor = YES;
	self.effect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 0.8f);;
	return YES;
}

- (void)render
{
	float vertices[] = {
		0, 0,
		0, 5,
		5, 0,
		5, 5
	};

	[self.effect prepareToDraw];
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
