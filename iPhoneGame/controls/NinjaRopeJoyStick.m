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

- (id)initWithCenter:(GLKVector2) posit region:(unsigned) regionR grabRegion:(unsigned) grabRegion joyRadius:(float) joyLen toggleBounds:(float) toggleB
{
	//- (id)initWithCenter:(GLKVector2) posit region:(unsigned) regionR toggleBounds:(float) toggleB
	self = [super initWithCenter:posit region:regionR grabRegion:grabRegion joyRadius:joyLen toggleBounds:toggleB];
	if(self)
	{
		player = game->player;
		
		return self;
	}
	return nil;
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
