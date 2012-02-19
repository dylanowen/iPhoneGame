//
//  GameViewController.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

#import "GameModel.h"

@interface GameViewController()
{
	GLuint _dirtVertexBuffer;
	GLuint _dirtIndexBuffer;
	
	float viewLeftBottom[2];
	float viewWH[2];
	float change[2];
	
	float _back;
}

@property (nonatomic, strong) GameModel *mainGame;

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation GameViewController

@synthesize mainGame = _mainGame;
@synthesize context = _context;
@synthesize effect = _effect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{

	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)setupGL
{
	viewLeftBottom[0] = WIDTH / 2;
	viewLeftBottom[1] = HEIGHT / 2;
	
	viewWH[0] = self.view.bounds.size.width;
	viewWH[1] = self.view.bounds.size.height;
	
	[EAGLContext setCurrentContext:self.context];
	self.effect = [[GLKBaseEffect alloc] init];
	
	glGenBuffers(1, &_dirtVertexBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, _dirtVertexBuffer);
	glBufferData(GL_ARRAY_BUFFER, sizeof(self.mainGame->dirt), self.mainGame->dirt, GL_DYNAMIC_DRAW);
	
	//self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.bounds.size.width / 4, 0, self.view.bounds.size.height / 4, 1, -1);
	//[effect prepareToDraw];
	
	/*
	glGenBuffers(1, &_dirtIndexBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _dirtIndexBuffer);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(self.mainGame->dirtIndices), self.mainGame->dirtIndices, GL_STATIC_DRAW);
	*/

}

- (void)viewDidLoad
{
	[super viewDidLoad];
	 
	_back = -30.0f;
	 
	self.context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
	 
	if(!self.context)
	{
		NSLog(@"Failed to create ES context");
	}
	 
	GLKView *view = (GLKView *) self.view;
	view.context = self.context;
	 
	self.mainGame = [[GameModel alloc] init];
	 
	[self setupGL];
}

- (void)tearDownGL
{
	[EAGLContext setCurrentContext:self.context];
	
	glDeleteBuffers(1, &_dirtVertexBuffer);
	//glDeleteBuffers(1, &_dirtIndexBuffer);
	
	self.effect = nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
	 
	 [self tearDownGL];
    
	 if([EAGLContext currentContext] == self.context)
	 {
		[EAGLContext setCurrentContext:nil];
	 }
	 
	 self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);	
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClearColor(0.1, 0.1, 0.1, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.effect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, _dirtVertexBuffer);
	//glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _dirtIndexBuffer);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(DirtVertex), (const GLvoid *) offsetof(DirtVertex, position)); 
	glEnableVertexAttribArray(GLKVertexAttribColor);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(DirtVertex), (const GLvoid *) offsetof(DirtVertex, color));
	
	//NSLog(@"count = %llu", sizeof(self.mainGame->dirtIndices)/sizeof(self.mainGame->dirtIndices[0]));
	
	//glDrawElements(GL_POINTS, WIDTH * HEIGHT, GL_UNSIGNED_BYTE, 0);
	
	glDrawArrays(GL_POINTS, 0, WIDTH * HEIGHT);
}

- (void)update
{
	viewLeftBottom[0] += change[0];
	viewLeftBottom[1] += change[1];

	self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(viewLeftBottom[0], viewLeftBottom[0] + viewWH[0], viewLeftBottom[1], viewLeftBottom[1] + viewWH[1], 1, -1);
	//NSLog(@"")
}

- (void) modChange:(CGPoint) loci
{
	if(loci.x < 20)
	{
		change[0] = loci.x - 20;
	}
	else if(loci.x > self.view.bounds.size.width - 20)
	{
		change[0] = loci.x - self.view.bounds.size.width + 20;
	}
	else
	{
		change[0] = 0;
	}
	if(loci.y < 20)
	{
		change[1] = loci.y - 20;
	}
	else if(loci.y > self.view.bounds.size.height - 20)
	{
		change[1] = loci.y - self.view.bounds.size.height + 20;
	}
	else
	{
		change[1] = 0;
	}
	NSLog(@"(%f, %f) (%f, %f)", loci.x, loci.y, change[0], change[1]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self modChange: [[touches anyObject] locationInView: self.view]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self modChange: [[touches anyObject] locationInView: self.view]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	change[0] = 0;
	change[1] = 0;
}

@end
