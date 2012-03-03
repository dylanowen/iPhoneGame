//
//  Bullets.m
//  iPhoneGame
//
//  Created by Lion User on 02/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bullets.h"

#import <GLKit/GLKit.h>

#import "GameModel.h"
#import "GLProgram.h"
#import "BulletParticle.h"

@interface Bullets()
{
	GLuint modelViewUniform;
}

@property (nonatomic, strong) GLProgram *program;

@property (strong, nonatomic) NSMutableArray *projectiles;

@end

@implementation Bullets

@synthesize game = _game;
@synthesize program = _program;
@synthesize projectiles = _projectiles;

- (id)initWithModel:(GameModel *) game
{
	self = [super init];
	if(self)
	{
		self.game = game;
		
		self.projectiles = [[NSMutableArray arrayWithCapacity: 0] init];
		
		//load and setup the shaders
		self.program = [[GLProgram alloc] initWithVertexShaderFilename: @"bulletShader" fragmentShaderFilename: @"bulletShader"];

		positionAttribute = [self.program addAttribute: @"position"];
		
		if(![self.program link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [self.program programLog]); 
			NSLog(@"Frag Log: %@", [self.program fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [self.program vertexShaderLog]);
			self.program = nil;
		}
		else
		{
			NSLog(@"Bullet shaders loaded.");
		}

		modelViewUniform = [self.program uniformIndex:@"modelViewProjectionMatrix"];
		
		return self;
	}
	return nil;
}

- (void)addBulletWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius
{
	[self.projectiles addObject: [[BulletParticle alloc] initWithBulletsModel:self position:posit velocity:veloc destructionRadius:radius]];
}

- (void)updateWithLastUpdate:(float) time
{
	//remove objects that say they're done
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.projectiles count]; i++)
	{
		if(![[self.projectiles objectAtIndex: i] updateAndKeep: time])
		{
			[indexes addIndex: i];
		}
	}
	[self.projectiles removeObjectsAtIndexes: indexes];
	
	
}

- (void)render
{
	for(unsigned i = 0; i < [self.projectiles count]; i++)
	{
		[self.program use];
		glUniformMatrix4fv(modelViewUniform, 1, 0, self.game.projectionMatrix.m);
		[[self.projectiles objectAtIndex: i] render];
	}
	[self.projectiles makeObjectsPerformSelector:@selector(render)];
}

@end
