//
//  ZombieCharacter.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

#import "Globals.h"
#import "GameModel.h"
#import "Environment.h"
#import "Particles.h"
#import "BloodParticle.h"
#import "TextureLoader.h"

#define DS_DESTRUCTION_RADIUS 5

@interface Zombie()
{
	Character *player;
	Particles *particles;
	
	int movementSpeed;
}
@end

@implementation Zombie

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		player = (Character *) game->player;
		particles = game->particles;
		texture = [game.textureLoader getTextureDescription:@"zombie.png"];
		characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		jumpHeight = 55;
		
		movementSpeed = (arc4random() % 4) + 4;
		
		return self;
	}
	return nil;
}

- (bool)update
{
	GLKVector2 normMovement = GLKVector2Normalize(GLKVector2Subtract(player->position, position));
	movement = GLKVector2MultiplyScalar(normMovement, movementSpeed);
	//NSLog(@"(%.2f %.2f)", movement.x, movement.y);
	if(normMovement.y < -0.85f)
	{
		[self jump];
	}
	if(arc4random() % 10 == 0)
	{
		GLKVector2 dig = GLKVector2Add(position, GLKVector2Make(-2.0f, -5.0f));
		if(normMovement.x < -0.6f)
		{
			dig.x -= 1.0f;
		}
		else if(normMovement.x > 0.6f)
		{
			dig.x += 1.0f;
		}
		if(normMovement.y < -0.6f)
		{
			dig.y -= 1.0f;
		}
		else if(normMovement.y > 0.6f)
		{
			dig.y += 2.0f;
		}
		
		[env editRect:YES leftX:dig.x topY:dig.y width:5 height:10];
	}
	
	[super update];
	if(animateTimer >= .25f)
	{
		currentFrame++;
		if(currentFrame > 3)
		{
			currentFrame = 0;
		}
		if(self.health < 500)
		{
			characterTextureBuffer = [texture getFrameBuffer:currentFrame + 4];
		}
		else
		{
			characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		}
		animateTimer = 0;
	}
	
	if(GLKVector2Length(GLKVector2Subtract(player->position, position)) < 4)
	{
		player.health -= 8;
		[particles addBloodWithPosition:player->position power:75 colorType:BloodColorRed];
	}
	
	if(self.health < 0)
	{
		[particles addBulletWithPosition:GLKVector2Add(position, GLKVector2Make(10.0f, 0.0f)) velocity:GLKVector2Make(75.0f, 0.0f) destructionRadius:8 damage:50];
		[particles addBulletWithPosition:GLKVector2Add(position, GLKVector2Make(5.0f, 8.6f)) velocity:GLKVector2Make(37.0f, 65.0f) destructionRadius:8 damage:50];
		[particles addBulletWithPosition:GLKVector2Add(position, GLKVector2Make(-5.0f, 8.6f)) velocity:GLKVector2Make(-37.0f, 65.0f) destructionRadius:8 damage:50];
		[particles addBulletWithPosition:GLKVector2Add(position, GLKVector2Make(-10.0f, 0.0f)) velocity:GLKVector2Make(-75.0f, 0.0f) destructionRadius:8 damage:50];
		[particles addBulletWithPosition:GLKVector2Add(position, GLKVector2Make(-5.0f, -8.6f)) velocity:GLKVector2Make(-37.0f, -65.0f) destructionRadius:8 damage:50];
		[particles addBulletWithPosition:GLKVector2Add(position, GLKVector2Make(5.0f, -8.6f)) velocity:GLKVector2Make(37.0f, -65.0f) destructionRadius:8 damage:50];
		return NO;
	}
	
	return YES;
}

//debug movement vector
/*
- (void)render
{
	[super render];

	float vertices2[6] = {
		0, 0,
		0, 4,
		movement.x, movement.y
	};

	GLKBaseEffect *tempEffect = [[GLKBaseEffect alloc] init];
	tempEffect.useConstantColor = YES;
	tempEffect.constantColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.3f);
	tempEffect.transform.projectionMatrix = projection;
	tempEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0);

	[tempEffect prepareToDraw];

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices2);
	
	glDrawArrays(GL_TRIANGLES, 0, 3);

	glDisableVertexAttribArray(GLKVertexAttribPosition);
}
*/

@end
