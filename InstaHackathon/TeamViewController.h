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

//  Buttons for Category choices
@property (weak, nonatomic) IBOutlet UIButton *firstCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *secondCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthCategoryButton;

//  Timer properties
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) int countDown;
@end
