//
//  WeaponViewController.m
//  iPhoneGame
//
//  Created by Rucha Heda on 3/20/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "WeaponViewController.h"
#import "Settings.h"

@implementation WeaponViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)regularBullet:(id)sender {
    Settings* GS = [Settings sharedManager];
    [GS setWeapon:0];
	[self performSegueWithIdentifier: @"selectedGun" sender: self];
}

- (IBAction)sniper:(id)sender {
    Settings* GS = [Settings sharedManager];
    [GS setWeapon:1];
	[self performSegueWithIdentifier: @"selectedGun" sender: self];
}

- (IBAction)machineGun:(id)sender {
    Settings* GS = [Settings sharedManager];
    [GS setWeapon:2];
	[self performSegueWithIdentifier: @"selectedGun" sender: self];
}

- (IBAction)shotgun:(id)sender {
    Settings* GS = [Settings sharedManager];
    [GS setWeapon:3];
	[self performSegueWithIdentifier: @"selectedGun" sender: self];
}

- (IBAction)bulletsWithGravity:(id)sender {
    Settings* GS = [Settings sharedManager];
    [GS setWeapon:4];
	[self performSegueWithIdentifier: @"selectedGun" sender: self];
}
@end
