//
//  TeamTimersViewController.m
//  InstaHackathon
//
//  Created by Bobby Schuchert on 8/23/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "TeamTimersViewController.h"
#import "Team.h"
#import "Category.h"

@interface TeamTimersViewController ()

@end

@implementation TeamTimersViewController
@synthesize currentTeam = _currentTeam;
@synthesize timerLabel = _timerLabel;
@synthesize teamNameLabel = _teamNameLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize startButton = _startButton;
@synthesize timeSelectControl;
@synthesize sysSoundTestPath;


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
    
    // add some awesomeness to the team name label
    //_teamNameLabel.textColor = [UIColor whiteColor];
    _teamNameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15];
    _teamNameLabel.shadowOffset = CGSizeMake(0, -2.0);
    
    // clear the default labels just in case our object doesn't load.
    _teamNameLabel.text = @"";
    _categoryLabel.text = @"";
    
    // load our object details into the nice labels
    if (_currentTeam) {
        _teamNameLabel.text = _currentTeam.teamName;
        _categoryLabel.text = [NSString stringWithFormat:@"Category: %@", _currentTeam.chosenCategory.categoryName];
        
    }
    
    //Load our sound(s)
    NSURL *path   = [[NSBundle mainBundle] URLForResource: @"censor-beep-1" withExtension: @"aifc"];
    sysSoundTestPath = (__bridge CFURLRef)path;
    AudioServicesCreateSystemSoundID(sysSoundTestPath, &soundID);
    
    
}

- (void)viewDidUnload
{
    [self setTimerLabel:nil];
    [self setStartButton:nil];
    [self setTimeSelectControl:nil];
    [self setTeamNameLabel:nil];
    [self setCategoryLabel:nil];
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

-(void)stopCountdown {
    running = NO;
    paused = NO;
    [_startButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    [countdownTimer invalidate];
    countdownTimer = nil;
    //[self showValidCountdownLabel];
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
    
    //Assign the number of seconds we have left in the countdown
    countdownSeconds = (NSInteger) timeInterval;
    
    // change the font to red when we get to 10 seconds or less
    if (countdownSeconds <= 10) {
        _timerLabel.textColor = [UIColor redColor];
        
    }
    
    // prevent from going past 0 seconds
    if (countdownSeconds <= 0) {
        [self stopCountdown];
    }
    
    // play our warning beep when we hit certain threshholds
    if (previousCountdownSecond != countdownSeconds) {
        
        previousCountdownSecond = countdownSeconds;
        
        
        switch (countdownSeconds) {
            case 30:
                [self playBeep];
                break;
            
            case 10:
                [self playBeep];
                break;
            case 5:
                [self playBeep];
                break;
            case 4:
                [self playBeep];
                break;
            case 3:
                [self playBeep];
                break;
            case 2:
                [self playBeep];
                break;
            case 1:
                [self playBeep];
                break;
            case 0:
                [self playBeep];
                break;
                
            default:
                break;
        }
        
        
    }
    
    
}

#pragma mark - Beeps

-(void)playBeep {
    AudioServicesPlaySystemSound(soundID);
}


@end
