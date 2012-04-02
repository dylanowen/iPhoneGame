//
//  HighScores.h
//  iPhoneGame
//
//  Created by Dylan Owen on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScore : NSObject

@property (nonatomic) int score;

+ (id)sharedManager;

@end
