//
//  Particles.m
//  iPhoneGame
//
//  Created by Lion User on 02/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
To dramatically increase the performance of the bullets completely remove the bulletParticle class and handle everything here in a single array
There might be a lot of cost moving the array aroud, but overall I think there would be an improvement. Also drawing to openGL would probably be
faster
*/

#import "Particles.h"

#import <GLKit/GLKit.h>

#import "GameModel.h"
#import "GLProgram.h"
#import "BulletParticle.h"
#import "BloodParticle.h"

@interface Particles()
{
GLuint bulletModelViewUniform;
GLuint bulletColorUniform;
GLuint bloodModelViewUniform;
}

@property (nonatomic, strong) GLProgram *bulletProgram;
@property (nonatomic, strong) GLProgram *bloodProgram;

@property (strong, nonatomic) NSMutableArray *bullets;
@property (strong, nonatomic) NSMutableArray *blood;

@end

@implementation Particles

@synthesize game = _game;
@synthesize bulletProgram = _bulletProgram;
@synthesize bloodProgram = _bloodProgram;
@synthesize bullets = _bullets;
@synthesize blood = _blood;

- (id)initWithModel:(GameModel *) game
{
	self = [super init];
	if(self)
	{
		self.game = game;

		self.bullets = [[NSMutableArray arrayWithCapacity: 0] init];
		self.blood = [[NSMutableArray arrayWithCapacity: 0] init];

		//load and setup the bullet shaders
		self.bulletProgram = [[GLProgram alloc] initWithVertexShaderFilename: @"particleShaderConstantColor" fragmentShaderFilename: @"particleShader"];
		bulletPositionAttribute = [self.bulletProgram addAttribute: @"position"];
		if(![self.bulletProgram link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [self.bulletProgram programLog]);
			NSLog(@"Frag Log: %@", [self.bulletProgram fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [self.bulletProgram vertexShaderLog]);
			self.bulletProgram = nil;
		}
		else
		{
			NSLog(@"Bullet shaders loaded.");
		}
		bulletModelViewUniform = [self.bulletProgram uniformIndex:@"modelViewProjectionMatrix"];
		bulletColorUniform = [self.bulletProgram uniformIndex:@"color"];

		//load and setup the blood shaders
		self.bloodProgram = [[GLProgram alloc] initWithVertexShaderFilename: @"particleShader" fragmentShaderFilename: @"particleShader"];
		bloodPositionAttribute = [self.bloodProgram addAttribute: @"position"];
		bloodColorAttribute = [self.bloodProgram addAttribute: @"color"];
		if(![self.bloodProgram link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [self.bloodProgram programLog]);
			NSLog(@"Frag Log: %@", [self.bloodProgram fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [self.bloodProgram vertexShaderLog]);
			self.bloodProgram = nil;
		}
		else
		{
			NSLog(@"Blood shaders loaded.");
		}
		bloodModelViewUniform = [self.bloodProgram uniformIndex:@"modelViewProjectionMatrix"];

		return self;
	}
	return nil;
}

- (void)addBulletWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius
{
	[self.bullets addObject: [[BulletParticle alloc] initWithParticles:self position:posit velocity:veloc destructionRadius:radius]];
}

- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power
{
	[self addBloodWithPosition:posit power:power colorType:0];
}

- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType count:(int) count
{
	while(count > 0)
	{
		[self addBloodWithPosition:posit power:power colorType:colorType];
		count--;
	}
}

- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType
{
	[self.blood addObject: [[BloodParticle alloc] 
									initWithParticles:self 
									position:posit 
									velocity:GLKVector2MultiplyScalar(GLKVector2Make(((float) (arc4random() % 200)) / 100.0f - 1.0f, ((float) (arc4random() % 200)) / 100.0f - 1.0f), power) 
									colorType:colorType]
	 ];
}

- (void)updateWithLastUpdate:(float) time
{
	//remove bullets that say they're done
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.bullets count]; i++)
	{
		if(![[self.bullets objectAtIndex: i] updateAndKeep: time])
		{
			[indexes addIndex: i];
		}
	}
	[self.bullets removeObjectsAtIndexes: indexes];

	//NSLog(@"%d bullets", [self.bullets count]);

	//remove blood that say they're done
	indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.blood count]; i++)
	{
		if(![[self.blood objectAtIndex: i] updateAndKeep: time])
		{
			[indexes addIndex: i];
		}
	}
	[self.blood removeObjectsAtIndexes: indexes];
	
	//NSLog(@"%d bullets %d blood", [self.bullets count], [self.blood count]);
}

- (void)render
{
	[self.bulletProgram use];
	glUniformMatrix4fv(bulletModelViewUniform, 1, 0, self.game.projectionMatrix.m);
	glUniform4f(bulletColorUniform, 0.6, 0.6, 0.6, 1.0);
	[self.bullets makeObjectsPerformSelector:@selector(render)];


	[self.bloodProgram use];
	glUniformMatrix4fv(bloodModelViewUniform, 1, 0, self.game.projectionMatrix.m);
	[self.blood makeObjectsPerformSelector:@selector(render)];
}

@end
