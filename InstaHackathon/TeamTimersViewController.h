//
//  TeamTimersViewController.h
//  InstaHackathon
//
//  Created by Bobby Schuchert on 8/23/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTimersViewController : UIViewController {

    NSInteger selectedTimerValue;
    NSInteger countdownSeconds;
    NSTimer *countdownTimer;
    NSDate *targetDate;
    NSDate *pauseDate;
    BOOL paused;
    BOOL running;
}


- (IBAction)startButtonPressed:(UIButton *)sender;
- (IBAction)resetButtonPressed:(UIButton *)sender;
- (IBAction)timeSelectChanged:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSelectControl;

@end
