//
//  TeamTimersViewController.h
//  InstaHackathon
//
//  Created by Bobby Schuchert on 8/23/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class Team;

@interface TeamTimersViewController : UIViewController {

    NSInteger selectedTimerValue;
    NSInteger countdownSeconds;
    NSInteger previousCountdownSecond;
    NSTimer *countdownTimer;
    NSDate *targetDate;
    NSDate *pauseDate;
    BOOL paused;
    BOOL running;
    SystemSoundID soundID;
    
}


- (IBAction)startButtonPressed:(UIButton *)sender;
- (IBAction)resetButtonPressed:(UIButton *)sender;
- (IBAction)timeSelectChanged:(UISegmentedControl *)sender;

@property (strong, nonatomic) Team *currentTeam;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSelectControl;
@property (readwrite) CFURLRef sysSoundTestPath;

@end
