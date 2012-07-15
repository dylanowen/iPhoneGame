//
//  NinjaRopeJoyStick.m
//  iPhoneGame
//
//  Created by Dylan Owen on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NinjaRopeJoyStick.h"

#import "Globals.h"
#import "GameModel.h"
#import "Player.h"
#import "NinjaRope.h"

@interface NinjaRopeJoyStick()
{
	Player *player;
}
@end

@implementation NinjaRopeJoyStick

- (void)setPlayer:(Player *) play
{
	player = play;
}

- (bool)touchesBegan:(GLKVector2) loci
{
	bool result = [super touchesBegan: loci];
	if(result)
	{
		if(!toggle)
		{
			lastVelocity = velocity = GLKVector2Make(0.0f, 0.0f);
		}
	}
	return result;
}

- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesMoved: loci lastTouch: last];
	if(result)
	{
		if(!toggle)
		{
			lastVelocity = velocity = GLKVector2Make(0.0f, 0.0f);
		}
	}
	return result;
}

- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last
{
	bool result = [super touchesEnded: loci lastTouch: last];
	if(result)
	{
		if(GLKVector2Length(GLKVector2Subtract(last, origin)) > toggleBounds)
		{
			[player->ninjaRope shoot:lastVelocity];
		}
		else
		{
			[player->ninjaRope cancel];
		}
		toggle = NO;
	}
	return result;
}

- (void)touchesCancelled
{
	[super touchesCancelled];
	toggle = NO;
}

- (GLKVector2) calculateVelocity
{
	//I figure for the toggle joystick there wont be power associated with shooting so no matter what it's 1
	return GLKVector2Normalize(GLKVector2Subtract(position, origin));
}

@end
