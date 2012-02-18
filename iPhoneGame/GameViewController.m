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

- (void)viewDidLoad
{
    [super viewDidLoad];
	 
	 self.context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
	 
	 if(!self.context)
	 {
		NSLog(@"Failed to creat ES context");
	 }
	 
	 GLKView *view = (GLKView *) self.view;
	 view.context = self.context;
	 
	 self.mainGame = [[GameModel alloc] init];
}

- (void)setupGL
{
	[EAGLContext setCurrentContext:self.context];
	self.effect = [[GLKBaseEffect alloc] init];
	
	glGenBuffers(1, &_dirtVertexBuffer);
	glBindBuffer(GL_ARRAY_BUFFER, _dirtVertexBuffer);
	glBufferData(GL_ARRAY_BUFFER, sizeof(self.mainGame->dirt), self.mainGame->dirt, GL_DYNAMIC_DRAW);
	
	glGenBuffers(1, &_indexBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _dirtIndexBuffer);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(self.mainGame->dirtIndices), self.mainGame->dirtIndices, GL_STATIC_DRAW);

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

@end
