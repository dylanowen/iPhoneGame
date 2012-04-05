//
//  Player.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#import "GameConstants.h"
#import "GameModel.h"
#import "Particles.h"
#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"

@interface Player()
{
	bool switchTexture;
	
	Particles *particles;
	
	GLKBaseEffect *laserEffect;
	GLuint laserVertexBuffer;
	GLuint laserIndicesBuffer;
	GLuint laserColorOnBuffer;
	GLuint laserColorOffBuffer;
	
	GLKMatrix4 laserCenter;
	
}

- (GLKMatrix4)centerView;

@end

@implementation Player


- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		texture = [model.textureLoader getTextureDescription:@"character.png"];
		particles = model.particles;
		
		laserEffect = [model.effectLoader getEffectForName:@"CharLaserSight"];
		if(laserEffect == nil)
		{
			laserEffect = [model.effectLoader addEffectForName:@"CharLaserSight"];
			laserEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, model.view.bounds.size.width, model.view.bounds.size.height, 0, 1, -1);
		}
		
		laserVertexBuffer = [model.bufferLoader getBufferForName:@"CharLaserSight"];
		if(laserVertexBuffer == 0)
		{
			float vertices[] = {
				20, -1,
				20, 1,
				25, -1,
				25, 1,
				30, -1,
				30, 1,
				35, -1,
				35, 1,
				40, -1,
				40, 1,
				45, -1,
				45, 1,
			};
			laserVertexBuffer = [model.bufferLoader addBufferForName:@"CharLaserSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserVertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		laserIndicesBuffer = [model.bufferLoader getBufferForName:@"CharLaserIndicesSight"];
		if(laserIndicesBuffer == 0)
		{
			GLuint indices[] = {
				0, 1, 2,
				2, 3, 1,
				4, 5, 6,
				6, 7, 5,
				8, 9, 10,
				10, 11, 9,
			};
			laserIndicesBuffer = [model.bufferLoader addBufferForName:@"CharLaserIndicesSight"];
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, laserIndicesBuffer);
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		}
	
		laserColorOnBuffer = [model.bufferLoader getBufferForName:@"CharLaserOnSight"];
		if(laserColorOnBuffer == 0)
		{
			float color[48];
			for(unsigned i = 0; i < 48; i += 4)
			{
				color[i + 0] = 0.8;
				color[i + 1] = 0.8;
				color[i + 2] = 0.8;
				color[i + 3] = 0.6;
			}
			laserColorOnBuffer = [model.bufferLoader addBufferForName:@"CharLaserOnSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserColorOnBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		laserColorOffBuffer = [model.bufferLoader getBufferForName:@"CharLaserOffSight"];
		if(laserColorOffBuffer == 0)
		{
			float color[48];
			for(unsigned i = 0; i < 48; i += 4)
			{
				color[i + 0] = 0.8;
				color[i + 1] = 0.1;
				color[i + 2] = 0.1;
				color[i + 3] = 0.4;
			}
			laserColorOffBuffer = [model.bufferLoader addBufferForName:@"CharLaserOffSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserColorOffBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		shoot = false;
		laserCenter = GLKMatrix4MakeTranslation(model.view.bounds.size.width / 2, model.view.bounds.size.height / 2, 0);

		switchTexture = false;
		characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		jumpHeight = 65;
		
		return self;
	}
	return nil;
}

- (GLKMatrix4)update:(float) time
{
	[super update:time];
	projection = [self centerView];
	
	laserEffect.transform.modelviewMatrix = GLKMatrix4RotateZ(laserCenter, atan2f(look.y, look.x));
	
	if(animateTimer >= .25f)
	{
		currentFrame++;
		if(currentFrame > 3)
		{
			currentFrame = 0;
		}
		if(self.health < 500)
		{
			//randomly bleed
			if(arc4random() % 5 == 0)
			{
				[particles addBloodWithPosition:position power:25];
			}
			characterTextureBuffer = [texture getFrameBuffer:currentFrame + 4];
		}
		else
		{
			characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		}
		animateTimer = 0;
	}
	//slight healing
	/*
	if(arc4random() % 70 == 0 && self.health < 100)
	{
		self.health += 5;
	}
	*/
	return projection;
}

- (GLKMatrix4)centerView
{
	float left, top, right, bottom;
	left = position.x - (DYNAMIC_VIEW_WIDTH / 2);
	top = position.y - (DYNAMIC_VIEW_HEIGHT / 2);
	right = left + DYNAMIC_VIEW_WIDTH;
	bottom = top + DYNAMIC_VIEW_HEIGHT;
	return GLKMatrix4MakeOrtho(left, right, bottom, top, 0, 10);
}

- (void)render
{
	if(!GLKVector2AllEqualToVector2(look, GLKVector2Make(0.0f, 0.0f)))
	{
		[laserEffect prepareToDraw];
	
		glBindBuffer(GL_ARRAY_BUFFER, laserVertexBuffer);
		glEnableVertexAttribArray(GLKVertexAttribPosition);
		glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
		if(shoot)
		{
			glBindBuffer(GL_ARRAY_BUFFER, laserColorOnBuffer);
		}
		else
		{
			glBindBuffer(GL_ARRAY_BUFFER, laserColorOffBuffer);
		}
		glEnableVertexAttribArray(GLKVertexAttribColor);
		glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, laserIndicesBuffer);
		
		glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_INT, 0);
		
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		
		glDisableVertexAttribArray(GLKVertexAttribPosition);
		glDisableVertexAttribArray(GLKVertexAttribColor);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}
	[super render];
}

@end
