//
//  GameViewController.h
//  iPhoneGame
//
//  Created by Lion User on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GameViewController : GLKViewController <GLKViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *pauseView;

- (void)pauseGame;
- (IBAction)resumeGame:(id)sender;

@end
