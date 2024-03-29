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

#import "Globals.h"
#import "GameModel.h"
#import "GLProgram.h"
#import "BulletParticle.h"
#import "BulletParticleGrav.h"
#import "BulletParticleBouncy.h"
#import "HealingParticle.h"

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
	
	GLuint healthParticleModelViewUniform;
	
	GLProgram *healthProgram;
}

@property (nonatomic, strong) GLProgram *bulletProgram;
@property (nonatomic, strong) GLProgram *bloodProgram;

@property (strong, nonatomic) NSMutableArray *bullets;
@property (strong, nonatomic) NSMutableArray *blood;
@property (strong, nonatomic) NSMutableArray *healingEffect;

@end

@implementation Particles

@synthesize bulletProgram = _bulletProgram;
@synthesize bloodProgram = _bloodProgram;
@synthesize bullets = _bullets;
@synthesize blood = _blood;
@synthesize healingEffect = _healingEffect;

- (id)initWithModel:(GameModel *) model
{
	self = [super init];
	if(self)
	{
		game = model;
		
		self.bullets = [[NSMutableArray arrayWithCapacity: 0] init];
		self.blood = [[NSMutableArray arrayWithCapacity: 0] init];
		self.healingEffect = [[NSMutableArray arrayWithCapacity:0] init];
		
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
		
		healthProgram = [[GLProgram alloc] initWithVertexShaderFilename: @"healthParticle" fragmentShaderFilename: @"particleShader"];
		healthParticleInitialPosition = [healthProgram addAttribute: @"initialPosition"];
		healthParticleTime = [healthProgram addAttribute: @"time"];
		if(![healthProgram link])
		{
			NSLog(@"Link failed");
			NSLog(@"Program Log: %@", [healthProgram programLog]);
			NSLog(@"Frag Log: %@", [healthProgram fragmentShaderLog]);
			NSLog(@"Vert Log: %@", [healthProgram vertexShaderLog]);
			healthProgram = nil;
		}
		else
		{
			NSLog(@"Health particle shaders loaded.");
		}
		healthParticleModelViewUniform = [healthProgram uniformIndex:@"modelViewProjectionMatrix"];
		
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
	[self addBloodWithPosition:posit power:power colorType:BloodColorRed];
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
}

- (void)addHealingEffect:(GLKVector2) posit
{
	posit = GLKVector2Add(posit, GLKVector2Make(-3, 6));
	
	for(unsigned i = 0; i < 6; i++)
	{
		[self.healingEffect addObject:[[HealingParticle alloc] initWithParticles:self position:GLKVector2Add(posit, GLKVector2Make(i, 0))]];
		[self.healingEffect addObject:[[HealingParticle alloc] initWithParticles:self position:GLKVector2Add(posit, GLKVector2Make(i, -1))]];
	}
}

- (void)update
{
	//remove bullets that say they're done
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.bullets count]; i++)
	{
		if(![[self.bullets objectAtIndex: i] updateAndKeep])
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
		if(![[self.blood objectAtIndex: i] updateAndKeep])
		{
			[indexes addIndex: i];
		}
	}
	[self.blood removeObjectsAtIndexes: indexes];
	
	indexes = [NSMutableIndexSet indexSet];
	for(unsigned i = 0; i < [self.healingEffect count]; i++)
	{
		if(![[self.healingEffect objectAtIndex: i] updateAndKeep])
		{
			[indexes addIndex: i];
		}
	}
	[self.healingEffect removeObjectsAtIndexes: indexes];
	//NSLog(@"%d bullets %d blood", [self.bullets count], [self.blood count]);
}

- (void)render
{
	if([self.bullets count] > 0)
	{
		[self.bulletProgram use];
		glUniformMatrix4fv(bulletModelViewUniform, 1, 0, game->dynamicProjection.m);
		glUniform4f(bulletColorUniform, 0.8, 0.8, 0.8, 1.0);
		[self.bullets makeObjectsPerformSelector:@selector(render)];
	}

	if([self.blood count] > 0)
	{
		[self.bloodProgram use];
		glUniformMatrix4fv(bloodModelViewUniform, 1, 0, game->dynamicProjection.m);
		[self.blood makeObjectsPerformSelector:@selector(render)];
	}
	
	if([self.healingEffect count] > 0)
	{
		[healthProgram use];
		glUniformMatrix4fv(healthParticleModelViewUniform, 1, 0, game->dynamicProjection.m);
		[self.healingEffect makeObjectsPerformSelector:@selector(render)];
	}
	
	//NSLog(@"Particles: %d", [self.bullets count] + [self.blood count] + [self.bloodGPU count] + [self.healingEffect count]);
}

@end
