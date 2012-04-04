//
//  Item.h
//  iPhoneGame
//
//  Created by Dylan Owen on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;
@class Environment;
@class Player;
@class TextureDescription;

@interface Item : NSObject
{

@protected
	GameModel *game;
	Environment *env;
	Player *player;
	
	GLKBaseEffect *textureEffect;
	GLKBaseEffect *healthEffect;
	TextureDescription *texture;
	
	GLuint vertexBuffer;
	GLuint textureBuffer;
	
	GLKVector2 position;
	GLKVector2 velocity;
	
	int precision;
	
	float timer;
	float disappearTime;
	
	float pickupDistance;
}

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit;

- (bool)updateAndKeep:(float) time;
- (void)pickedUp;
- (void)render;

@end
