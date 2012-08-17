//
//  TeamViewController.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "TeamViewController.h"
#import "Category.h"


@interface TeamViewController ()

@end

@implementation TeamViewController

#pragma mark - Properties
@synthesize firstCategoryButton = _firstCategoryButton;
@synthesize secondCategoryButton = _secondCategoryButton;
@synthesize thirdCategoryButton = _thirdCategoryButton;
@synthesize fourthCategoryButton = _fourthCategoryButton;
@synthesize teamNameLabel = _teamNameLabel;
@synthesize countDownLabel = _countDownLabel;
@synthesize chooseDestinyButton = _chooseDestinyButton;
@synthesize audioPlayer = _audioPlayer;
@synthesize countDownTimer = _countDownTimer;
@synthesize countDown = _countDown;
@synthesize currentEvent = _currentEvent;

#pragma mark - Initialization
- (void)setCurrentEvent:(Event *)currentEvent
{
    if(_currentEvent != currentEvent) {
        _currentEvent = currentEvent;
    }
    //  Test variables
    NSSet *categorySet = [currentEvent categoryList];
    NSSet *teamSet = [currentEvent teamList];
    
}

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
    [self startCountDown];
}

- (void)viewDidUnload
{
    [self setChooseDestinyButton:nil];
    [self setFirstCategoryButton:nil];
    [self setSecondCategoryButton:nil];
    [self setThirdCategoryButton:nil];
    [self setFourthCategoryButton:nil];
    [self setCountDownLabel:nil];
    [self setTeamNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Timer
- (void)startCountDown
{
    self.countDown = 30;
    self.countDownLabel.text = [NSString stringWithFormat:@"%d", self.countDown];
    self.countDownLabel.hidden = NO;
    if(!self.countDownTimer) {
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.00
                                                               target:self
                                                             selector:@selector(updateTime:)
                                                             userInfo:nil
                                                              repeats:YES];
        
    }
}

- (void)updateTime:(NSTimer *)timerParam
{
    self.countDown--;
    if(self.countDown == 0) {
        [self clearCountDownTimer];
        //  Do rest of code here
    }
    
    self.countDownLabel.text = [NSString stringWithFormat:@"%d", self.countDown];
}

- (void)clearCountDownTimer
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    self.countDownLabel.hidden = YES;
}
- (IBAction)chooseDestinyButtonClicked:(id)sender {
//    CFBundleRef mainBundle = CFBundleGetMainBundle();
//    CFURLRef soundFileURLRef;
//    soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"3f8b1b_MK3_Choose_Your_Destiny_Sound_Effect", CFSTR("mp3"), NULL);
//    UInt32 soundID;
//    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
//    AudioServicesPlaySystemSound(soundID);
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"3f8b1b_MK3_Choose_Your_Destiny_Sound_Effect"
                                                                        ofType:@"mp3"]];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.audioPlayer play];
                  
}

//NSString *msg = [NSString stringWithFormat:@"Hello %@ %@, %@ has arrived at the front desk.", [self.pointOfContactSelected objectForKey:@"firstName"], [self.pointOfContactSelected objectForKey:@"lastName"], self.guestItem.firstName];
////  Build an info object and convert it to JSON
//NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
//                      kTropoToken,
//                      @"token",
//                      [self.pointOfContactSelected objectForKey:@"cellPhone"],
//                      @"numberToDial",
//                      msg,
//                      @"msg",
//                      nil];
//
////  Convert object to data
//NSData *jsonData = [info toJSON];
//
////  Making a URL reqest with the created data
//NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kTropoURLSession];
//[request setHTTPMethod:@"POST"];
//[request setValue:@"application/json" forHTTPHeaderField:@"accept"];
//[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//[request setHTTPBody:jsonData];
//
////  Sending the request
//NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
@end
