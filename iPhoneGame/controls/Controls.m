//
//  Controls.m
//  iPhoneGame
//
//  Created by Lion User on 25/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Controls.h"

#import <GLKit/GLKit.h>

#import "GameConstants.h"
#import "GameModel.h"
#import "EffectLoader.h"
#import "JoyStick.h"
#import "ToggleJoyStick.h"
#import "Button.h"

@interface Controls()
{
	GameModel *model;
}
@end

@implementation Controls

@synthesize move = _move;
@synthesize look = _look;
@synthesize jump = _jump;

- (id)initWithModel: (GameModel *) game
{
	self = [super init];
	if(self)
	{
		model = game;
		
		GLKBaseEffect *effect = [game.effectLoader getEffectForName:@"ControlEffect"];
		if(effect == nil)
		{
			effect = [game.effectLoader addEffectForName:@"ControlEffect"];
			effect.texture2d0.envMode = GLKTextureEnvModeReplace;
			effect.texture2d0.target = GLKTextureTarget2D;
			effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, model.view.bounds.size.width, model.view.bounds.size.height, 0, 1, -1);
		}
		
		self.move = [[JoyStick alloc] initWithCenter: GLKVector2Make(65, model.view.bounds.size.height - 65) model:model];
		self.look = [[ToggleJoyStick alloc] initWithCenter: GLKVector2Make(model.view.bounds.size.width - 65, model.view.bounds.size.height - 65) model:model];
		self.jump = [[Button alloc] initWithCenter: GLKVector2Make(model.view.bounds.size.width - 30, model.view.bounds.size.height - 145) model:model];
		
		return self;
	}
	return nil;
}

- (void)touchesBegan:(NSSet *)touches
{
	for(UITouch *touch in touches)
	{
		CGPoint loci = [touch locationInView: touch.view];
		GLKVector2 vLoci = GLKVector2Make(loci.x, loci.y);
		if([self.move touchesBegan: vLoci])
		{
		
		}
		else if([self.look touchesBegan: vLoci])
		{
		
		}
		else if([self.jump touchesBegan: vLoci])
		{
	
		}
		//NSLog(@"Not grabbed (%f, %f)", vLoci.x, vLoci.y);
	}
	//self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(100.0f, 0.0f, 0.0f);
}
- (void)touchesMoved:(NSSet *)touches
{
	for(UITouch *touch in touches)
	{
		CGPoint loci = [touch locationInView: touch.view];
		CGPoint last = [touch previousLocationInView: touch.view];
		GLKVector2 vLoci = GLKVector2Make(loci.x, loci.y);
		GLKVector2 vLast = GLKVector2Make(last.x, last.y);
		
		//NSLog(@"M %d:(%.1f, %.1f) L:(%.1f, %.1f) %d", index, loci.x, loci.y, last.x, last.y, touch.phase);
		
		if([self.move touchesMoved: vLoci lastTouch: vLast])
		{
		
		}
		else if([self.look touchesMoved: vLoci lastTouch: vLast])
		{
		
		}
		else if([self.jump touchesMoved: vLoci lastTouch: vLast])
		{
			
		}
		//NSLog(@"Not grabbed (%f, %f)", last.x, last.y);
	}
}
- (void)touchesEnded:(NSSet *)touches
{
	for(UITouch *touch in touches)
	{
		CGPoint loci = [touch locationInView: touch.view];
		CGPoint last = [touch previousLocationInView: touch.view];
		GLKVector2 vLoci = GLKVector2Make(loci.x, loci.y);
		GLKVector2 vLast = GLKVector2Make(last.x, last.y);
		
		//NSLog(@"M %d:(%.1f, %.1f) L:(%.1f, %.1f) %d", index, loci.x, loci.y, last.x, last.y, touch.phase);
		
		if([self.move touchesEnded: vLoci lastTouch: vLast])
		{
		
		}
		else if([self.look touchesEnded: vLoci lastTouch: vLast])
		{
		
		}
		else if([self.jump touchesEnded: vLoci lastTouch: vLast])
		{
			
		}
		//NSLog(@"Not grabbed (%f, %f)", last.x, last.y);
	}
}
- (void)touchesCancelled:(NSSet *)touches
{
	[self.move touchesCancelled];
	[self.look touchesCancelled];
	[self.jump touchesCancelled];
}

- (void)render
{
	[self.move render];
	[self.look render];
	[self.jump render];
}

@end
