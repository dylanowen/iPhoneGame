//
//  GameModel.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

#import "Globals.h"

#import "MatrixFunctions.h"

#import "TextureLoader.h"
#import "EffectLoader.h"
#import "BufferLoader.h"
#import "VAOLoader.h"

#import "Background.h"
#import "Environment.h"
#import "JoyStick.h"
#import "ToggleJoyStick.h"
#import "Button.h"
#import "Tracker.h"

#import "Player.h"
#import "NinjaRope.h"

#import "Particles.h"
#import "BulletParticle.h"
#import "BloodParticle.h"
#import "Text.h"

#import "Pickups.h"

#import "Settings.h"

@interface GameModel()
{
	
}

@end

@implementation GameModel

@synthesize textureLoader = _textureLoader;
@synthesize effectLoader = _effectLoader;
@synthesize bufferLoader = _bufferLoader;
@synthesize vaoLoader = _vaoLoader;

- (id)initWithView:(GameViewController *) gameController
{
	self = [super init];
	if(self)
	{
		controller = gameController;
		
		staticProjection = GLKMatrix4MakeOrtho(0, STATIC_VIEW_WIDTH, STATIC_VIEW_HEIGHT, 0, 0, 10);
		dynamicProjection = CenterOrtho(0, 0);

		self.textureLoader = [[TextureLoader alloc] init];
		self.effectLoader = [[EffectLoader alloc] init];
		self.bufferLoader = [[BufferLoader alloc] init];
		self.vaoLoader = [[VAOLoader alloc] init];
		
		background = [[Background alloc] initWithModel:self];
		particles = [[Particles alloc] initWithModel:self];
		pickups = [[Pickups alloc] initWithModel:self];
		
		availableWeapons = [[NSMutableArray alloc] init];
		controls = [[Controls alloc] initWithModel:self];
		
		
		return self;
	}
	return nil;
}

- (bool)update
{
	//it's negative because up is negative...
	if(controls.move->velocity.y < -0.5f)
	{
		[player jump];
	}
	
	player->movement.x = controls.move->velocity.x * 60;
	//self.player->movement.y = self.controls.move->velocity.y * 5;
	
	player->lookGun = controls.look->lastVelocity;
	player->shootGun = controls.look->toggle;
	player->lookRope = controls->shootRope->velocity;
	
	//the player updates the projection matrix
	[player update];
	screenCenter = player->position;
	MoveOrthoVector(&dynamicProjection, screenCenter);
	
	return YES;
}

- (bool)checkBulletHit:(BulletParticle *) bullet
{
	return NO;
}

- (void)itemPickedUp:(Item *) item
{
	
}

- (void)render
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	[background render];
	//[environment render];
	[particles render];
	[pickups render];
	[controls render];
	
	//debug
	/*
	switch(glGetError())
	{
		case GL_NO_ERROR:
			break;
		case GL_INVALID_ENUM:
			NSLog(@"GL_INVALID_ENUM");
			break;
		case GL_INVALID_VALUE:
			NSLog(@"GL_INVALID_VALUE");
			break;
		case GL_INVALID_OPERATION:
			NSLog(@"GL_INVALID_OPERATION");
			break;
		case GL_STACK_OVERFLOW:
			NSLog(@"GL_STACK_OVERFLOW");
			break;
		case GL_STACK_UNDERFLOW:
			NSLog(@"GL_STACK_UNDERFLOW");
			break;
		case GL_OUT_OF_MEMORY:
			NSLog(@"GL_OUT_OF_MEMORY");
			break;
		default:
			NSLog(@"dunnno");
	}
	*/
}

@end
