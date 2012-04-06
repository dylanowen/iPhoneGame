//
//  GameViewController.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

#import "ZombieSwarm.h"

@interface GameViewController()
{
	
}

@property (nonatomic, strong) GameModel *mainGame;
@property (strong, nonatomic) EAGLContext *context;

@end

@implementation GameViewController

@synthesize mainGame = _mainGame;
@synthesize context = _context;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.delegate = self;
	
	self.context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
	if(!self.context)
	{
		NSLog(@"Failed to create ES context");
	}
	
	GLKView *view = (GLKView *) self.view;
	view.context = self.context;
	view.multipleTouchEnabled = YES;
	
	[EAGLContext setCurrentContext:self.context];
	
	self.preferredFramesPerSecond = 60;
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	glDisable(GL_DEPTH_TEST);
	glDepthMask(GL_FALSE);
	
	glDisable(GL_STENCIL_TEST);
	
	//glClearColor(0.5, 0.5, 0.5, 1.0);
	
	self.mainGame = [[ZombieSwarm alloc] initWithView:self.view];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	//tear down openGL
	[EAGLContext setCurrentContext:self.context];
    
	if([EAGLContext currentContext] == self.context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	self.context = nil;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
	if(![self.mainGame update: self.timeSinceLastUpdate])
	{
		//self.paused = true;
		[self performSegueWithIdentifier: @"gameOver" sender: self];
	}
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	[self.mainGame render];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.mainGame->controls touchesBegan: touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.mainGame->controls touchesMoved: touches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.mainGame->controls touchesEnded: touches];
}
- (void)touchesCancelled:(NSSet *)touches
{
	[self.mainGame->controls touchesCancelled: touches];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{

	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

@end
