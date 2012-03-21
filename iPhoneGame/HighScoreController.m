//
//  HighScoreController.m
//  iPhoneGame
//
//  Created by Dylan Owen on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoreController.h"

#import "GameConstants.h"
#import "HighScore.h"

@interface HighScoreController ()
{
	bool updated;
}

- (void)saveFilePaths;
- (NSString *)dataFilePath:(NSString *) fileName;

@end

@implementation HighScoreController

@synthesize highScores;
@synthesize score1;
@synthesize score2;
@synthesize score3;
@synthesize score4;
@synthesize score5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
	
	NSString *filePath = [self dataFilePath: @"highScores"];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		NSLog(@"Loading from highScores");
		NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		self.highScores = [unarchiver decodeObjectForKey:@"highScores"];
		[unarchiver finishDecoding];
	}
	else
	{
		NSLog(@"No saved files to load");
		self.highScores = [[NSMutableArray alloc] initWithObjects:
								 [NSNumber numberWithUnsignedInt:0], [[NSString alloc] initWithString:@"nobody"], 
								 [NSNumber numberWithUnsignedInt:0], [[NSString alloc] initWithString:@"nobody"], 
								 [NSNumber numberWithUnsignedInt:0], [[NSString alloc] initWithString:@"nobody"], 
								 [NSNumber numberWithUnsignedInt:0], [[NSString alloc] initWithString:@"nobody"], 
								 [NSNumber numberWithUnsignedInt:0], [[NSString alloc] initWithString:@"nobody"], 
								 nil];
		[self saveFilePaths];
	}
	
	updated = false;
	
	[self setScores];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *newName = [[alertView textFieldAtIndex:0] text];
	
	HighScore *newScore = [HighScore sharedManager];
	for(unsigned i = 0; i < [self.highScores count]; i += 2)
	{
		if(newScore.score > [[self.highScores objectAtIndex:i] unsignedIntValue])
		{
			[self.highScores insertObject:newName atIndex:i];
			[self.highScores insertObject:[NSNumber numberWithUnsignedInt:newScore.score] atIndex:i];
			[self.highScores removeObjectAtIndex:[self.highScores count] - 1];
			[self.highScores removeObjectAtIndex:[self.highScores count] - 1];
			[self setScores];
			[self saveFilePaths];
			return;
		}
	}
}

- (void)setScores
{
	self.score1.text = [[NSString alloc] initWithFormat:@"%@: %@", [self.highScores objectAtIndex:0], [self.highScores objectAtIndex:1]];
	self.score2.text = [[NSString alloc] initWithFormat:@"%@: %@", [self.highScores objectAtIndex:2], [self.highScores objectAtIndex:3]];
	self.score3.text = [[NSString alloc] initWithFormat:@"%@: %@", [self.highScores objectAtIndex:4], [self.highScores objectAtIndex:5]];
	self.score4.text = [[NSString alloc] initWithFormat:@"%@: %@", [self.highScores objectAtIndex:6], [self.highScores objectAtIndex:7]];
	self.score5.text = [[NSString alloc] initWithFormat:@"%@: %@", [self.highScores objectAtIndex:8], [self.highScores objectAtIndex:9]];
}

- (void)viewDidUnload
{
	[self setScore1:nil];
	[self setScore2:nil];
	[self setScore3:nil];
	[self setScore4:nil];
	[self setScore5:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)dataFilePath:(NSString *) fileName
{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [path objectAtIndex:0];
	return [documentDirectory stringByAppendingFormat:@"/%@%@", FILE_PREFIX,fileName];
}

- (void)saveFilePaths
{
	NSLog(@"Saving to highScores");
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self.highScores forKey:@"highScores"];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath: @"highScores"] atomically:YES];
}

- (IBAction)updateScores:(id)sender
{
	if(!updated)
	{
		updated = true;
	bool test = NO;
	HighScore *newScore = [HighScore sharedManager];
	for(unsigned i = 0; i < [self.highScores count]; i += 2)
	{
		if(newScore.score > [[self.highScores objectAtIndex:i] unsignedIntValue])
		{
			test = YES;
			break;
		}
	}
	
	if(test)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HighScore!" message:@"Please enter your name." delegate:self cancelButtonTitle:@"Go!" otherButtonTitles: nil];
		alert.alertViewStyle = UIAlertViewStylePlainTextInput;
		[alert show];
	}
	}
}
@end
