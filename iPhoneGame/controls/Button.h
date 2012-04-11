//
//  Button.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;
@class TextureDescription;

@interface Button : NSObject
{
@public
	bool down;
	bool pressed;
@protected
	GLKBaseEffect *effect;
	
	GLKVector2 position;
	
	GLKVector2 lastTouch;
	
	float radius;
	
	TextureDescription *buttonTexture;
	
	GLuint vertexBuffer;
	
	void (^callback)();
}

- (id)initWithCenter:(GLKVector2) posit texture:(NSString *) textName radius:(unsigned) rad callback:(void(^)(bool result)) back model:(GameModel *) game;

- (bool)touchesBegan:(GLKVector2) loci;
- (bool)touchesMoved:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (bool)touchesEnded:(GLKVector2) loci lastTouch:(GLKVector2) last;
- (void)touchesCancelled;

- (void)render;

@end
