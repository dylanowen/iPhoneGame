//
//  MainMenuViewController.m
//  iPhoneGame
//
//  Created by Rucha Heda on 3/20/12.
//  Copyright (c) 2012 UC Davis. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Settings.h"

@implementation MainMenuViewController
@synthesize weaponLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"INITWITHNIBNAME CALLED MAIN MENU");
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"VIEWDIDLOAD CALLED MAIN MENU");
    Settings* GS = [Settings sharedManager];
    NSLog(@"Weapon: %d", [GS weapon]);
    switch ([GS weapon]) {
        case 1:
            weaponLabel.text = @"Sniper";
            break;
        case 2:
            weaponLabel.text = @"Machine Gun";
            break;
        case 3:
            weaponLabel.text = @"Shot Gun";
            break;
        case 4:
            weaponLabel.text = @"Bouncy ShotGun";
            break;
        default:
            weaponLabel.text = @"Bouncy Machine Gun";
            break;
    }
}


- (void)viewDidUnload
{
    [self setWeaponLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

@end
