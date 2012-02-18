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
	[EAGLContext setCurrentContext:self.context];
	self.effect = [[GLKBaseEffect alloc] init];
	
	glGenBuffers(1, &_dirtVertexBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, _dirtVertexBuffer);
	glBufferData(GL_ARRAY_BUFFER, sizeof(self.mainGame->dirt), self.mainGame->dirt, GL_DYNAMIC_DRAW);
	
	glGenBuffers(1, &_dirtIndexBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _dirtIndexBuffer);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(self.mainGame->dirtIndices), self.mainGame->dirtIndices, GL_STATIC_DRAW);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	 
	 _back = -30.0f;
	 
	 self.context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
	 
	 if(!self.context)
	 {
		NSLog(@"Failed to creat ES context");
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
	glDeleteBuffers(1, &_dirtIndexBuffer);
	
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

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[self.effect prepareToDraw];
	
	glBindBuffer(GL_ARRAY_BUFFER, _dirtVertexBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _dirtIndexBuffer);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(DirtVertex), (const GLvoid *) offsetof(DirtVertex, position)); 
	glEnableVertexAttribArray(GLKVertexAttribColor);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(DirtVertex), (const GLvoid *) offsetof(DirtVertex, color));
	
	glDrawElements(GL_POINTS, sizeof(self.mainGame->dirtIndices)/sizeof(self.mainGame->dirtIndices[0]), GL_UNSIGNED_BYTE, 0);
}

#pragma mark - GLKViewControllerDelegate

- (void)update
{
	float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
	GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 10.0f, 100.0f);
	self.effect.transform.projectionMatrix = projectionMatrix;
	
	_back -= 1.0 * self.timeSinceLastUpdate;
	
	self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, _back);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"back: %f", _back);
	//self.paused = !self.paused;
}

@end
