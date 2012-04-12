//
//  Player.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#import "Globals.h"
#import "GameConstants.h"
#import "MatrixFunctions.h"
#import "GameModel.h"
#import "Particles.h"
#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"

#import "NinjaRope.h"
#import "MachineGun.h"

#import "BulletParticle.h"

@interface Player()
{
	bool switchTexture;
	
	Particles *particles;
	
	GLKBaseEffect *laserEffect;
	GLuint laserVertexBuffer;
	GLuint laserIndicesBuffer;
	GLuint laserColorOnBuffer;
	GLuint laserColorOffBuffer;
	GLuint laserNinjaColorBuffer;
	
	GLKMatrix4 laserCenter;
}

@end

@implementation Player

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		texture = [game.textureLoader getTextureDescription:@"character.png"];
		particles = game->particles;
		
		laserEffect = [game.effectLoader getEffectForName:@"CharLaserSight"];
		if(laserEffect == nil)
		{
			laserEffect = [game.effectLoader addEffectForName:@"CharLaserSight"];
			laserEffect.transform.projectionMatrix = game->staticProjection;
		}
		
		laserVertexBuffer = [game.bufferLoader getBufferForName:@"CharLaserSight"];
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
			laserVertexBuffer = [game.bufferLoader addBufferForName:@"CharLaserSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserVertexBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		laserIndicesBuffer = [game.bufferLoader getBufferForName:@"CharLaserIndicesSight"];
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
			laserIndicesBuffer = [game.bufferLoader addBufferForName:@"CharLaserIndicesSight"];
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, laserIndicesBuffer);
			glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		}
	
		laserColorOnBuffer = [game.bufferLoader getBufferForName:@"CharLaserOnSight"];
		if(laserColorOnBuffer == 0)
		{
			float color[48];
			for(unsigned i = 0; i < 48; i += 4)
			{
				color[i + 0] = 1.0;
				color[i + 1] = 0.1;
				color[i + 2] = 0.1;
				color[i + 3] = 1.0;
			}
			laserColorOnBuffer = [game.bufferLoader addBufferForName:@"CharLaserOnSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserColorOnBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		laserColorOffBuffer = [game.bufferLoader getBufferForName:@"CharLaserOffSight"];
		if(laserColorOffBuffer == 0)
		{
			float color[48];
			for(unsigned i = 0; i < 48; i += 4)
			{
				color[i + 0] = 1.0;
				color[i + 1] = 0.1;
				color[i + 2] = 0.1;
				color[i + 3] = 0.7;
			}
			laserColorOffBuffer = [game.bufferLoader addBufferForName:@"CharLaserOffSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserColorOffBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		laserNinjaColorBuffer = [game.bufferLoader getBufferForName:@"CharNinjaSight"];
		if(laserNinjaColorBuffer == 0)
		{
			float color[48];
			for(unsigned i = 0; i < 48; i += 4)
			{
				color[i + 0] = 0.1;
				color[i + 1] = 1.1;
				color[i + 2] = 0.1;
				color[i + 3] = 1.0;
			}
			laserNinjaColorBuffer = [game.bufferLoader addBufferForName:@"CharNinjaSight"];
			glBindBuffer(GL_ARRAY_BUFFER, laserNinjaColorBuffer);
			glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
			glBindBuffer(GL_ARRAY_BUFFER, 0);
		}
		
		shootGun = false;
		ninjaRope = [[NinjaRope alloc] initWithModel:game player:self];
		
		laserCenter = GLKMatrix4MakeTranslation(game->view.bounds.size.width / 2, game->view.bounds.size.height / 2, 0);

		switchTexture = false;
		characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		jumpHeight = 85;
		
		return self;
	}
	return nil;
}

- (void)updateVelocity
{
	[ninjaRope update];
	velocity.x += ninjaRope->playerMovement.x;
	velocity.y += ninjaRope->playerMovement.y + GRAVITY;
	//apply friction
	velocity = GLKVector2Add(velocity, GLKVector2MultiplyScalar(velocity, DRAG));
	//NSLog(@"(%.5f, %.5f) -> (%.5f, %.5f) -> (%.5f, %.5f)", temp2.x, temp2.y, temp.x, temp.y, velocity.x, velocity.y);
}

- (void)update
{
	[super update];
	
	if(shootGun)
	{
		[currentGun shootAtPosition:position direction: lookGun];
	}
	
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
	
	[currentGun update];
}

- (BOOL)checkBullet:(BulletParticle *) bullet
{
	//use squared length
	if(GLKVector2Length(GLKVector2Subtract(bullet->position, position)) < 6)
	{
		self.health -= bullet->damage;
		[game->particles addBloodWithPosition:bullet->position power:75 colorType:BloodColorRed count:4];
		return YES;
	}
	return NO;
}

- (void)render
{
	laserEffect.transform.modelviewMatrix = GLKMatrix4RotateZ(laserCenter, atan2f(lookGun.y, lookGun.x));
	
	[laserEffect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, laserVertexBuffer);
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (void *) 0);
	
	if(shootGun)
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
	
	if(!GLKVector2AllEqualToVector2(lookRope, GLKVector2Make(0.0f, 0.0f)))
	{
		laserEffect.transform.modelviewMatrix = GLKMatrix4RotateZ(laserCenter, atan2f(lookRope.y, lookRope.x));
		
		[laserEffect prepareToDraw];
		
		glBindBuffer(GL_ARRAY_BUFFER, laserNinjaColorBuffer);
		glEnableVertexAttribArray(GLKVertexAttribColor);
		glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, (void *) 0);
		
		glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_INT, 0);
	}
	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		
	glDisableVertexAttribArray(GLKVertexAttribPosition);
	glDisableVertexAttribArray(GLKVertexAttribColor);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	[super render];
	
	[ninjaRope render];
}

@end
