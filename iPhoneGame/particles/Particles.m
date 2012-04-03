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
#import "BulletParticleGrav.h"
#import "BulletParticleBouncy.h"
#import "BloodParticle.h"
#import "BloodGPUParticle.h"

typedef struct
{
	float initialPosition[2];
	float color[4];
	float time;
} bloodGPUPhysicsElement;

@interface Particles()
{
	GLuint bulletModelViewUniform;
	GLuint bulletColorUniform;
	GLuint bloodModelViewUniform;
	
	GLuint bloodGPUModelViewUniform;
	GLuint bloodGPUGravity;
}

@property (nonatomic, strong) GLProgram *bulletProgram;
@property (nonatomic, strong) GLProgram *bloodProgram;
@property (nonatomic, strong) GLProgram *bloodGPUPhysProgram;

@property (strong, nonatomic) NSMutableArray *bullets;
@property (strong, nonatomic) NSMutableArray *blood;
@property (strong, nonatomic) NSMutableArray *bloodGPU;

@end

@implementation Particles

@synthesize game = _game;
@synthesize bulletProgram = _bulletProgram;
@synthesize bloodProgram = _bloodProgram;
@synthesize bloodGPUPhysProgram = _bloodGPUPhysProgram;
@synthesize bullets = _bullets;
@synthesize blood = _blood;
@synthesize bloodGPU = _bloodGPU;

- (id)initWithModel:(GameModel *) game
{
	self = [super init];
	if(self)
	{
		self.game = game;

		self.bullets = [[NSMutableArray arrayWithCapacity: 0] init];
		self.blood = [[NSMutableArray arrayWithCapacity: 0] init];
		self.bloodGPU = [[NSMutableArray arrayWithCapacity:0] init];
		
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
		
		//load and setup the blood shaders with the GPU physics
		self.bloodGPUPhysProgram = [[GLProgram alloc] initWithVertexShaderFilename: @"ParticleShaderGPUPhysics" fragmentShaderFilename: @"particleShader"];
		bloodGPUInitialPosition = [self.bloodGPUPhysProgram addAttribute: @"initialPosition"];
		bloodGPUInitialVelocity = [self.bloodGPUPhysProgram addAttribute: @"initialVelocity"];
		bloodGPUColor = [self.bloodGPUPhysProgram addAttribute: @"color"];
		bloodGPUTime = [self.bloodGPUPhysProgram addAttribute: @"time"];
		if(![self.bloodGPUPhysProgram link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [self.bloodGPUPhysProgram programLog]);
			NSLog(@"Frag Log: %@", [self.bloodGPUPhysProgram fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [self.bloodGPUPhysProgram vertexShaderLog]);
			self.bloodGPUPhysProgram = nil;
		}
		else
		{
			NSLog(@"Blood GPU physics shaders loaded.");
		}
		bloodGPUModelViewUniform = [self.bloodGPUPhysProgram uniformIndex:@"modelViewProjectionMatrix"];
		bloodGPUGravity = [self.bloodGPUPhysProgram uniformIndex:@"gravity"];
		
		return self;
	}
	return nil;
}

- (void)addBulletWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg
{
	[self.bullets addObject: [[BulletParticle alloc] initWithParticles:self position:posit velocity:veloc destructionRadius:radius damage:dmg]];
}

- (void)addBulletGravWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg
{
	[self.bullets addObject: [[BulletParticleGrav alloc] initWithParticles:self position:posit velocity:veloc destructionRadius:radius damage:dmg]];
}

- (void)addBulletBouncyWithPosition:(GLKVector2) posit velocity:(GLKVector2) veloc destructionRadius:(unsigned) radius damage:(int) dmg
{
	[self.bullets addObject: [[BulletParticleBouncy alloc] initWithParticles:self position:posit velocity:veloc destructionRadius:radius damage:dmg]];
}

- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power
{
	[self addBloodWithPosition:posit power:power colorType:0];
}

- (void)addBloodWithPosition:(GLKVector2) posit power:(unsigned) power colorType:(int) colorType count:(int) count
{
	while(count >= 0)
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

	[self.bloodGPU addObject: [[BloodGPUParticle alloc] 
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
	
	//update GPU blood with the new time and remove the ones that are out of range
	indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.bloodGPU count]; i++)
	{
		if(![[self.bloodGPU objectAtIndex: i] updateAndKeep: time])
		{
			[indexes addIndex: i];
		}
	}
	[self.bloodGPU removeObjectsAtIndexes: indexes];
	
	//NSLog(@"%d bullets %d blood", [self.bullets count], [self.blood count]);
}

- (void)render
{
	if([self.bullets count] > 0)
	{
		[self.bulletProgram use];
		glUniformMatrix4fv(bulletModelViewUniform, 1, 0, self.game.projectionMatrix.m);
		glUniform4f(bulletColorUniform, 0.6, 0.6, 0.6, 1.0);
		[self.bullets makeObjectsPerformSelector:@selector(render)];
	}

	if([self.blood count] > 0)
	{
		[self.bloodProgram use];
		glUniformMatrix4fv(bloodModelViewUniform, 1, 0, self.game.projectionMatrix.m);
		[self.blood makeObjectsPerformSelector:@selector(render)];
	}

	if([self.bloodGPU count] > 0)
	{
		[self.bloodGPUPhysProgram use];
		glUniformMatrix4fv(bloodGPUModelViewUniform, 1, 0, self.game.projectionMatrix.m);
		glUniform1f(bloodGPUGravity, -GRAVITY * 30);
		[self.bloodGPU makeObjectsPerformSelector:@selector(render)];
	}
	
	//NSLog(@"Particles: %d", [self.bullets count] + [self.blood count] + [self.bloodGPU count]);
}

@end
