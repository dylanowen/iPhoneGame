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
#import "JoyStick.h"
#import "ToggleJoyStick.h"

@interface Controls()
{
	
}

@property (strong, nonatomic) GameModel *game;

@end

@implementation Controls

@synthesize game = _game;

@synthesize move = _move;
@synthesize look = _look;

- (id)initWithModel: (GameModel *) game
{
	self = [super init];
	if(self)
	{
		self.game = game;
		self.move = [[JoyStick alloc] initWithCenter: GLKVector2Make(80, self.game.view.bounds.size.height - 80) view:self.game.view];
		self.look = [[ToggleJoyStick alloc] initWithCenter: GLKVector2Make(self.game.view.bounds.size.width - 80, self.game.view.bounds.size.height - 80) view:self.game.view];
		/*
		effect.texturingEnabled = YES;
		effect.texture2d0.envMode = GLKTextureEnvModeReplace;
		effect.texture2d0.target = GLKTextureTarget2D;
		effect.texture2d0.glName = texture.glName;
		*/
		
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
		else
		{
			
			//NSLog(@"Not grabbed (%f, %f)", vLoci.x, vLoci.y);
		}
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
		else
		{
			
			//NSLog(@"Not grabbed (%f, %f)", last.x, last.y);
		}
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
		else
		{
			
			//NSLog(@"Not grabbed (%f, %f)", last.x, last.y);
		}
	}
}
- (void)touchesCancelled:(NSSet *)touches
{
	[self.move touchesCancelled];
	[self.look touchesCancelled];
}

- (void)render
{
	[self.move render];
	[self.look render];
}

@end
