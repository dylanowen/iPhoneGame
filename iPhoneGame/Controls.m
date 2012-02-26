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
		self.move = [[JoyStick alloc] initWithCenter: CGPointMake(80, 80) view:self.game.view];
		self.look = [[JoyStick alloc] initWithCenter: CGPointMake(80, self.game.view.bounds.size.width - 80 - JOY_LENGTH_HALF) view:self.game.view];
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
		if([self.move touchesBegan: loci])
		{
		
		}
		else if([self.look touchesBegan: loci])
		{
		
		}
		else
		{
			
			NSLog(@"Not grabbed (%f, %f)", loci.x, loci.y);
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
		if([self.move touchesMoved: loci lastTouch: last])
		{
		
		}
		else if([self.look touchesMoved: loci lastTouch: last])
		{
		
		}
		else
		{
			
			NSLog(@"Not grabbed (%f, %f)", last.x, last.y);
		}
	}
}
- (void)touchesEnded:(NSSet *)touches
{
	[self.move touchesEnded];
	[self.look touchesEnded];
}
- (void)touchesCancelled:(NSSet *)touches
{
	
}

- (void)render
{
	[self.move render];
	[self.look render];
}

@end
