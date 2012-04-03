//
//  Particles.h
//  iPhoneGame
//
//  Created by Lion User on 02/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class GameModel;

@interface Particles : NSObject
{
@public
	GLuint bulletPositionAttribute;
	GLuint bloodPositionAttribute;
	GLuint bloodColorAttribute;
	
	GLuint bloodGPUInitialPosition;
	GLuint bloodGPUInitialVelocity;
	GLuint bloodGPUColor;
	GLuint bloodGPUTime;
}

@property (nonatomic, strong) GameModel *game;

- (id)initWithModel:(GameModel *) game;

- (void)addBulletWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;
- (void)addBulletGravWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;
- (void)addBulletBouncyWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg;
- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power;
- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType count:(int) count;
- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType;
- (void)updateWithLastUpdate:(float) time;
- (void)render;

@end
