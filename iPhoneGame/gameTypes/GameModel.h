//
//  GameModel.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "GameConstants.h"
#import "Controls.h"

@class GameViewController;
@class TextureLoader;
@class EffectLoader;
@class BufferLoader;
@class VAOLoader;
@class Background;
@class Environment;
@class Particles;
@class Controls;
@class BulletParticle;
@class Player;
@class Pickups;
@class Item;

@interface GameModel : NSObject
{
@public
	GameViewController *controller;
	
	Environment *environment;
	Particles *particles;
	Pickups *pickups;
	Controls *controls;
	
	Player *player;
	NSMutableArray *availableWeapons;
	GLKVector2 screenCenter;
	
	GLKMatrix4 staticProjection;
	GLKMatrix4 dynamicProjection;
@protected
	Background *background;
}

@property (strong, nonatomic) TextureLoader *textureLoader;
@property (strong, nonatomic) EffectLoader *effectLoader;
@property (strong, nonatomic) BufferLoader *bufferLoader;
@property (strong, nonatomic) VAOLoader *vaoLoader;

- (id)initWithView:(GameViewController *) gameController;

- (bool)update;
- (bool)checkBulletHit:(BulletParticle *) bullet;

- (void)itemPickedUp:(Item *) item;

- (void)render;

@end
