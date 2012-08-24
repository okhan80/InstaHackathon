//
//  TeamViewController.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Event.h"
#import "Team.h"

@interface TeamViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseDestinyButton;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) Event *currentEvent;

//Buttons for Category choices
@property (weak, nonatomic) IBOutlet UIButton *firstCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *secondCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *fifthCategoryButton;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMemberThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamCompanyHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamMembersHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *startButtonHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *categorySelectionHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerHelpLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerArrowHelpLabel;

//Timer properties
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) int countDown;

//Event properties
@property (strong, nonatomic) NSMutableArray *categorySet;
@property (strong, nonatomic) NSArray *teamSet;

//  Team
@property (strong, nonatomic) Team *currentTeam;
@property (nonatomic) int teamPosition;

@end