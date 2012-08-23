//
//  TeamTimersViewController.m
//  InstaHackathon
//
//  Created by Bobby Schuchert on 8/23/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "TeamTimersViewController.h"

@interface TeamTimersViewController ()

@end

@implementation TeamTimersViewController
@synthesize timerLabel = _timerLabel;
@synthesize startButton = _startButton;
@synthesize timeSelectControl;

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
	// Do any additional setup after loading the view.
    running = NO;
    paused = NO;
    selectedTimerValue = 60;
    [self showValidCountdownLabel];
}

- (void)viewDidUnload
{
    [self setTimerLabel:nil];
    [self setStartButton:nil];
    [self setTimeSelectControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - UI Control Stuff
- (IBAction)startButtonPressed:(UIButton *)sender {
    
    if (running) {
    
        if (paused) {
            
            //Resume
            [self resumeCountdown];
            
        } else {
            
            //Pause the current one
            [self pauseCountdown];
        }
        
    } else {
        
        //start a new countdown
        [self startNewCountdown];
    }
    
}

- (IBAction)resetButtonPressed:(UIButton *)sender {
    
    [self resetCountdown];
}

- (IBAction)timeSelectChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
		case 0:
			selectedTimerValue = 60;
            [self showValidCountdownLabel];
			break;
		case 1:
			selectedTimerValue = 120;
            [self showValidCountdownLabel];
			break;
            
		default:
            break;
    }
}



#pragma mark - Countdown Stuff

-(void)startNewCountdown {
    paused = NO;
    [_startButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
    targetDate = [[NSDate date] dateByAddingTimeInterval:selectedTimerValue];
    [self startTimer];
}

-(void)pauseCountdown {
    paused = YES;
    [_startButton setTitle:@"Resume Timer" forState:UIControlStateNormal];
    pauseDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [countdownTimer invalidate];
    countdownTimer = nil;
}

-(void)resumeCountdown {
    paused = NO;
    [_startButton setTitle:@"Pause Timer" forState:UIControlStateNormal];
    float pauseTime = -1*[pauseDate timeIntervalSinceNow];
    targetDate = [targetDate dateByAddingTimeInterval:pauseTime];
    [self startTimer];
}

-(void)resetCountdown {
    running = NO;
    [_startButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    [countdownTimer invalidate];
    countdownTimer = nil;
    [self showValidCountdownLabel];
}

-(void)showValidCountdownLabel {
    
    // don't touch it if we are running
    if (!running){
        
        NSDate *dateFromSeconds = [NSDate dateWithTimeIntervalSince1970:selectedTimerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
         
        _timerLabel.text =[dateFormatter stringFromDate:dateFromSeconds];
        
    }
    
}

#pragma mark - Timer Stuff

-(void)startTimer {

    running = YES;
    
    // Create a timer that fires every 10 ms
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)updateTimer {
    
    // roll through and calculate the time with a pretty format
    NSTimeInterval timeInterval = [targetDate timeIntervalSinceNow];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setDateFormat:@"mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    _timerLabel.text = timeString;
    
    countdownSeconds = (int) timeInterval;
    
    
    // change the font to red when we get to 10 seconds or less
    if (countdownSeconds <= 10) {
        _timerLabel.textColor = [UIColor redColor];
    }
}


@end
