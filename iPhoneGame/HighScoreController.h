//
//  HighScoreController.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreController : UIViewController

@property (strong, nonatomic) NSMutableArray *highScores;

@property (weak, nonatomic) IBOutlet UILabel *score1;
@property (weak, nonatomic) IBOutlet UILabel *score2;
@property (weak, nonatomic) IBOutlet UILabel *score3;
@property (weak, nonatomic) IBOutlet UILabel *score4;
@property (weak, nonatomic) IBOutlet UILabel *score5;

- (IBAction)updateScores:(id)sender;

@end
