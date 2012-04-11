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

@implementation Controls

@synthesize move = _move;
@synthesize look = _look;

- (id)initWithModel: (GameModel *) model
{
	self = [super init];
	if(self)
	{
		
		GLKBaseEffect *effect = [model.effectLoader getEffectForName:@"ControlEffect"];
		if(effect == nil)
		{
			effect = [model.effectLoader addEffectForName:@"ControlEffect"];
			effect.texture2d0.envMode = GLKTextureEnvModeReplace;
			effect.texture2d0.target = GLKTextureTarget2D;
			effect.transform.projectionMatrix = model->staticProjection;
		}
		
		self.move = [[JoyStick alloc] initWithCenter: GLKVector2Make(80, STATIC_VIEW_HEIGHT - 80) region:50 grabRegion:140 joyRadius:25 model:model];
		self.look = [[ToggleJoyStick alloc] initWithCenter: GLKVector2Make(STATIC_VIEW_WIDTH - 80, STATIC_VIEW_HEIGHT - 80) region:50 grabRegion:140 joyRadius:25 toggleBounds:30 model:model];
		shootRope = [[NinjaRopeJoyStick alloc] initWithCenter: GLKVector2Make(STATIC_VIEW_WIDTH / 2, STATIC_VIEW_HEIGHT / 2) region:40 grabRegion:25 joyRadius:25 toggleBounds:25 model:model];
		
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
		if([shootRope touchesBegan: vLoci])
		{
			
		}
		else if([self.move touchesBegan: vLoci])
		{
		
		}
		else if([self.look touchesBegan: vLoci])
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
		
		if([shootRope touchesMoved: vLoci lastTouch: vLast])
		{
			
		}
		else if([self.move touchesMoved: vLoci lastTouch: vLast])
		{
		
		}
		else if([self.look touchesMoved: vLoci lastTouch: vLast])
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
		
		if([shootRope touchesEnded: vLoci lastTouch: vLast])
		{
			
		}
		else if([self.move touchesEnded: vLoci lastTouch: vLast])
		{
		
		}
		else if([self.look touchesEnded: vLoci lastTouch: vLast])
		{
		
		}
		//NSLog(@"Not grabbed (%f, %f)", last.x, last.y);
	}
}
- (void)touchesCancelled:(NSSet *)touches
{
	[shootRope touchesCancelled];
	[self.move touchesCancelled];
	[self.look touchesCancelled];
}

- (void)render
{
	//[shootRope render];
	[self.move render];
	[self.look render];
}

@end
