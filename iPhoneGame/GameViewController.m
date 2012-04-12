//
//  GameViewController.m
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

#import "Globals.h"
#import "ZombieSwarm.h"
#import "Player.h"
#import "Weapon.h"

@interface GameViewController()
{
	GameModel *game;
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation GameViewController
@synthesize pauseView = _pauseView;

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
	
	game = [[ZombieSwarm alloc] initWithView:self.view];
}

- (void)viewDidUnload
{
	[self setPauseView:nil];
	[super viewDidUnload];
	
	//tear down openGL
	[EAGLContext setCurrentContext:self.context];
    
	if([EAGLContext currentContext] == self.context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	self.context = nil;
	game = nil;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{
	timeSinceUpdate = self.timeSinceLastUpdate;
	if(![game update])
	{
		[self performSegueWithIdentifier: @"gameOver" sender: self];
	}
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	[game render];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[game->controls touchesBegan: touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[game->controls touchesMoved: touches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[game->controls touchesEnded: touches];
}
- (void)touchesCancelled:(NSSet *)touches
{
	[game->controls touchesCancelled: touches];
}

- (void)pauseGame
{
	self.paused = true;
	self.pauseView.hidden = false;
}

- (IBAction)resumeGame:(id)sender
{
	self.pauseView.hidden = true;
	self.paused = false;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [game->availableWeapons count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return ((Weapon *) [game->availableWeapons objectAtIndex:row])->name;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	game->player->currentGun = [game->availableWeapons objectAtIndex:row];
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
