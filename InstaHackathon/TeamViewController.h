//
//  TeamViewController.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface TeamViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseDestinyButton;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end
