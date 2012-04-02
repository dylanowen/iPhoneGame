//
//  ZombieCharacter.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Zombie.h"

#import "GameModel.h"
#import "Environment.h"
#import "Particles.h"
#import "BloodParticle.h"
#import "TextureLoader.h"

#define MOVEMENT_SPEED 1

@interface Zombie()
{
	Character *player;
	Particles *particles;
}
@end

@implementation Zombie

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit
{
	self = [super initWithModel:model position:posit];
	if(self)
	{
		player = (Character *) model.player;
		particles = model.particles;
		texture = [model.textureLoader getTextureDescription:@"zombie.png"];
		characterTextureBuffer = [texture getFrameBuffer:currentFrame];
		jumpHeight = 45;
		
		return self;
	}
	return nil;
}

- (bool)update:(float) time projection:(GLKMatrix4) matrix
{
	GLKVector2 normMovement = GLKVector2Normalize(GLKVector2Subtract(player->position, position));
	movement = GLKVector2MultiplyScalar(normMovement, MOVEMENT_SPEED);
	//NSLog(@"(%.2f %.2f)", movement.x, movement.y);
	if(normMovement.y < -0.85f)
	{
		[self jump];
	}
	if(arc4random() % 10 == 0)
	{
		GLKVector2 dig = GLKVector2Add(GLKVector2Add(position, normMovement), GLKVector2Make(0, -4));
		//NSLog(@"(%f %f) + (%f, %f) -> (%f, %f)", position.x, position.y, movement.x, movement.y, dig.x, dig.y);
		[env deleteRadius:5 x:dig.x y:dig.y];
		dig = GLKVector2Add(dig, GLKVector2Make(0, 8));
		[env deleteRadius:5 x:dig.x y:dig.y];
	}
	
	[self update: time];
	projection = matrix;
	if(animateTimer >= .25f)
	{
		currentFrame++;
		if(currentFrame > 3)
		{
			currentFrame = 0;
		}
		if(health < 500)
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
		player->health -= 2;
		[particles addBloodWithPosition:player->position power:75 colorType:BloodColorRed];
	}
	return health > 0;
}

//debug movement vector
/*
- (void)render
{
	[super render];

	NSLog(@"%f %f", movement.x, movement.y);
	float vertices2[6] = {
		0, 0,
		0, 1,
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
