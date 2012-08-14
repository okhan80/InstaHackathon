//
//  TeamViewController.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "TeamViewController.h"


@interface TeamViewController ()

@end

@implementation TeamViewController
@synthesize chooseDestinyButton = _chooseDestinyButton;
@synthesize audioPlayer = _audioPlayer;

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
}

- (void)viewDidUnload
{
    [self setChooseDestinyButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
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

@end
