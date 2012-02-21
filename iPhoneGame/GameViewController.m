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

@property (nonatomic, strong) GameModel *mainGame;

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation GameViewController

@synthesize mainGame = _mainGame;
@synthesize context = _context;
@synthesize effect = _effect;

- (void)viewDidLoad
{
	[super viewDidLoad];
	 
	self.context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
	[EAGLContext setCurrentContext:self.context];
	
	GLKView *view = (GLKView *) self.view;
	view.context = self.context;
	self.delegate = self;
	
	self.effect = [[GLKBaseEffect alloc] init];
	 
	if(!self.context)
	{
		NSLog(@"Failed to create ES context");
	}
	 
	self.mainGame = [[GameModel alloc] initWithContext:self.context effect:self.effect];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	//tear down openGL
	[EAGLContext setCurrentContext:self.context];
	
	self.effect = nil;
    
	if([EAGLContext currentContext] == self.context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	 
	self.context = nil;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
	[self.mainGame update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	
	glClearColor(0.1, 0.9, 0.9, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	/*
	[self.effect prepareToDraw];
	
	float vertices[] = {-1, -1, 1, -1, 0, 1};
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	
	glDrawArrays(GL_TRIANGLES, 0, 3);
	glDisableVertexAttribArray(GLKVertexAttribPosition);
	*/
	[self.mainGame render];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.mainGame touchesBegan: [[touches anyObject] locationInView: self.view]];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.mainGame touchesBegan: [[touches anyObject] locationInView: self.view]];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);	
}

@end
