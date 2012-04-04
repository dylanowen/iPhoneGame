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

@class TextureLoader;
@class EffectLoader;
@class BufferLoader;
@class VAOLoader;
@class Environment;
@class Particles;
@class Controls;
@class BulletParticle;
@class Player;
@class Pickups;

@interface GameModel : NSObject
{
@public
	Pickups *pickups;
}

@property (strong, nonatomic) UIView *view;
@property (nonatomic) GLKMatrix4 projectionMatrix;

@property (strong, nonatomic) TextureLoader *textureLoader;
@property (strong, nonatomic) EffectLoader *effectLoader;
@property (strong, nonatomic) BufferLoader *bufferLoader;
@property (strong, nonatomic) VAOLoader *vaoLoader;

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) Environment *env;
@property (strong, nonatomic) Particles *particles;
@property (strong, nonatomic) Controls *controls;

@property (nonatomic) int zombieKills;

- (id)initWithView:(UIView *) view;

- (bool)updateWithLastUpdate:(float) time;
- (bool)checkCharacterHit:(BulletParticle *) bullet;

- (void)render;

@end
