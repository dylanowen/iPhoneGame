//
//  BulletParticle.h
//  iPhoneGame
//
//  Created by Lion User on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsObject.h"

@interface BulletParticle : PhysicsObject

- (id)initWithModel:(GameModel *) model position:(GLKVector2) posit velocity:(GLKVector2) veloc;

@end
