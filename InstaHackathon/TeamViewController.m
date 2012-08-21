//
//  TeamViewController.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "TeamViewController.h"
#import "Category.h"
#import "Team.h"
#import "TeamMember.h"
#import "NSDictionary+JSONCategories.h"
#import "AppDelegate.h"
#import "HackathonResultsViewController.h"

//  Macro to give back background queue
#define kBgQueueDefault dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kBGQueueHigh dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

@interface TeamViewController ()
@property (strong, nonatomic) NSMutableArray *randomizedCategories;
@end

@implementation TeamViewController

#pragma mark - Properties
@synthesize firstCategoryButton = _firstCategoryButton;
@synthesize secondCategoryButton = _secondCategoryButton;
@synthesize thirdCategoryButton = _thirdCategoryButton;
@synthesize fourthCategoryButton = _fourthCategoryButton;
@synthesize teamNameLabel = _teamNameLabel;
@synthesize teamMemberOneLabel = _teamMemberOneLabel;
@synthesize teamMemberTwoLabel = _teamMemberTwoLabel;
@synthesize teamMemberThreeLabel = _teamMemberThreeLabel;
@synthesize countDownLabel = _countDownLabel;
@synthesize chooseDestinyButton = _chooseDestinyButton;
@synthesize audioPlayer = _audioPlayer;
@synthesize countDownTimer = _countDownTimer;
@synthesize countDown = _countDown;
@synthesize currentEvent = _currentEvent;
@synthesize categorySet = _categorySet;
@synthesize teamSet = _teamSet;
@synthesize randomizedCategories = _randomizedCategories;


#pragma mark - Initialization
- (void)setCurrentEvent:(Event *)currentEvent {
    if(_currentEvent != currentEvent) {
        _currentEvent = currentEvent;
    }
    //  Test variables
    self.categorySet = [NSMutableArray arrayWithArray:[[currentEvent categoryList] allObjects]];
    
    NSArray *sortedTeamArray;
    sortedTeamArray = [[[currentEvent teamList] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(Team*)a draftOrder];
        NSNumber *second = [(Team*)b draftOrder];
        return [first compare:second];
    }];
    
    self.teamSet = sortedTeamArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.teamPosition = 0;
//    [self startCountDown];
    [self updateTeamView];
}

- (void)viewDidUnload {
    [self setChooseDestinyButton:nil];
    [self setFirstCategoryButton:nil];
    [self setSecondCategoryButton:nil];
    [self setThirdCategoryButton:nil];
    [self setFourthCategoryButton:nil];
    [self setCountDownLabel:nil];
    [self setTeamNameLabel:nil];
    [self setTeamMemberOneLabel:nil];
    [self setTeamMemberTwoLabel:nil];
    [self setTeamMemberThreeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"hackathonResultsSegue"]) {
        [(HackathonResultsViewController *)segue.destinationViewController fetchedResultsController];
    }
}

#pragma mark - Team Behavior
-(void)updateTeamView {
    
    if(self.teamPosition < [self.teamSet count]){
        self.currentTeam = [self.teamSet objectAtIndex:self.teamPosition];
        self.teamNameLabel.text = self.currentTeam.teamName;
        [self updateTeamMemberView];
        [self displayCategoriesForTeam:self.currentTeam];
        
    } else {
        [self performSegueWithIdentifier:@"hackathonResultsSegue" sender:self];
    }
}

/*
 * Updates the Team Member Labels based on the number of TeamMembers for the currentTeam.
 */
- (void) updateTeamMemberView {
    self.teamMemberOneLabel.hidden = YES;
    self.teamMemberTwoLabel.hidden = YES;
    self.teamMemberThreeLabel.hidden = YES;
    
    if([[self.currentTeam teamMemberList] count]>2){
        self.teamMemberThreeLabel.hidden = NO;
        self.teamMemberThreeLabel.text = [self getTeamMemberDisplayText:[[[self.currentTeam teamMemberList] allObjects] objectAtIndex:2]];
    }
    
    if([[self.currentTeam teamMemberList] count]>1){
        self.teamMemberTwoLabel.hidden = NO;
        self.teamMemberTwoLabel.text = [self getTeamMemberDisplayText:[[[self.currentTeam teamMemberList] allObjects] objectAtIndex:1]];
    }
    
    if([[self.currentTeam teamMemberList] count]>0){
        self.teamMemberOneLabel.hidden = NO;
        self.teamMemberOneLabel.text = [self getTeamMemberDisplayText:[[[self.currentTeam teamMemberList] allObjects] objectAtIndex:0]];
    }
}

/*
 * Builds a NSString representation of a TeamMember object in the format of fullname - companyName.
 */
- (NSString*) getTeamMemberDisplayText:(TeamMember*)teamMember {
    return [NSString stringWithFormat:@"%@%@%@", [teamMember fullName], @" -", [teamMember company]];
}

#pragma mark - Category Behavior
/*
 * Contains UI logic for displaying 1-4 randomized Cateogry Selection Buttons based on the passed in Team's teamOptions and the remaining number of
 * Hackathon Categories.
 *
 * NOTE: May want to consider a more flexible UI element.
 */
- (void)displayCategoriesForTeam:(Team*)team {
    
    if([team.teamOptions intValue]==2){
        self.thirdCategoryButton.hidden = YES;
        self.fourthCategoryButton.hidden = YES;
        
        self.randomizedCategories = [self selectUniqueRandomObjectsFromArray:2 forArray:self.categorySet];
        
        if([self.randomizedCategories count]==2){
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            [self.secondCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:1] categoryName] forState:UIControlStateNormal];
        } else {
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            self.secondCategoryButton.hidden = YES;
        }
    }
    
    if([team.teamOptions intValue]==3){
        self.thirdCategoryButton.hidden = NO;
        self.fourthCategoryButton.hidden = YES;
        
        self.randomizedCategories = [self selectUniqueRandomObjectsFromArray:3 forArray:self.categorySet];
        
        if([self.randomizedCategories count]==3){
            
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            [self.secondCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:1] categoryName] forState:UIControlStateNormal];
            [self.thirdCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:2] categoryName] forState:UIControlStateNormal];
            
        } else if([self.randomizedCategories count]==2){
            
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            [self.secondCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:1] categoryName] forState:UIControlStateNormal];
            self.thirdCategoryButton.hidden = YES;
            
        } else if([self.randomizedCategories count]==1){
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            self.secondCategoryButton.hidden = YES;
            self.thirdCategoryButton.hidden = YES;
        }
    }
    
    if([team.teamOptions intValue]==4){
        self.thirdCategoryButton.hidden = NO;
        self.fourthCategoryButton.hidden = NO;
        
        self.randomizedCategories = [self selectUniqueRandomObjectsFromArray:4 forArray:self.categorySet];
        
        if([self.randomizedCategories count]==4){
            
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            [self.secondCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:1] categoryName] forState:UIControlStateNormal];
            [self.thirdCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:2] categoryName] forState:UIControlStateNormal];
            [self.fourthCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:3] categoryName] forState:UIControlStateNormal];
            
        } else if([self.randomizedCategories count]==3){
            
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            [self.secondCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:1] categoryName] forState:UIControlStateNormal];
            [self.thirdCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:2] categoryName] forState:UIControlStateNormal];
            self.fourthCategoryButton.hidden = YES;
            
        } else if([self.randomizedCategories count]==2){
            
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            [self.secondCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:1] categoryName] forState:UIControlStateNormal];
            self.thirdCategoryButton.hidden = YES;
            self.fourthCategoryButton.hidden = YES;
            
        } else if([self.randomizedCategories count]==1){
            [self.firstCategoryButton setTitle:[[self.randomizedCategories objectAtIndex:0] categoryName] forState:UIControlStateNormal];
            self.secondCategoryButton.hidden = YES;
            self.thirdCategoryButton.hidden = YES;
            self.fourthCategoryButton.hidden = YES;
        }
    }
}

/**
 * Returns a NSArray of x randomly selected unique object for the passed in array where x = the number of desired random objects.
 */
-(NSMutableArray *)selectUniqueRandomObjectsFromArray:(int)numberOfObjects forArray:(NSArray*)array {
    
    NSMutableArray *randomCategories = [NSMutableArray array];
    int safeCounter = numberOfObjects;
    
    if(numberOfObjects>[array count]){
        safeCounter = [array count];
    }
    
    for (int i = 0; i < safeCounter; i++) {
        int randomIndex = arc4random_uniform([self.categorySet count]);
        Category *randomCategory = [self.categorySet objectAtIndex:randomIndex];
        
        while ([randomCategories containsObject:randomCategory]) {
            randomIndex = arc4random_uniform([self.categorySet count]);
            randomCategory = [self.categorySet objectAtIndex:randomIndex];
        }
        
        [randomCategories addObject:randomCategory];
    }
    
    return randomCategories;
}

#pragma mark - Button Actions
/*
 * Action for the CategoryOne UIButton that will assign the selected Category to the Team and prepare the view for the next one.
 */
- (IBAction)categoryOneSelected:(id)sender {
    [self removeSelectedCategory:self.firstCategoryButton.currentTitle];
    self.currentTeam.chosenCategory = [self.randomizedCategories objectAtIndex:0];
    self.currentTeam.hackathonCategoryId = self.currentTeam.chosenCategory.hackathonCategoryId;
    [self persistTeamDataToServiceForTeam:self.currentTeam];
    [self categoryButtonSelected];
}

- (IBAction)categoryTwoSelected:(id)sender {
    [self removeSelectedCategory:self.secondCategoryButton.currentTitle];
    self.currentTeam.chosenCategory = [self.randomizedCategories objectAtIndex:1];
    self.currentTeam.hackathonCategoryId = self.currentTeam.chosenCategory.hackathonCategoryId;
    [self persistTeamDataToServiceForTeam:self.currentTeam];
    [self categoryButtonSelected];
}

- (IBAction)categoryThreeSelected:(id)sender {
    [self removeSelectedCategory:self.thirdCategoryButton.currentTitle];
    self.currentTeam.chosenCategory = [self.randomizedCategories objectAtIndex:2];
    self.currentTeam.hackathonCategoryId = self.currentTeam.chosenCategory.hackathonCategoryId;
    [self persistTeamDataToServiceForTeam:self.currentTeam];
    [self categoryButtonSelected];
}

- (IBAction)categoryFourSelected:(id)sender {
    [self removeSelectedCategory:self.fourthCategoryButton.currentTitle];
    self.currentTeam.chosenCategory = [self.randomizedCategories objectAtIndex:3];
    self.currentTeam.hackathonCategoryId = self.currentTeam.chosenCategory.hackathonCategoryId;
    [self persistTeamDataToServiceForTeam:self.currentTeam];
    [self categoryButtonSelected];
}

/*
 * Action that occurs when any Category Button is pressed. It will increment the global team count, update the Team View and restart the countdown.
 */
- (void) categoryButtonSelected {
    self.teamPosition++;
    [self updateTeamView];
    [self startCountDown];
}

/*
 * Void method that removes the team's selected category from the global NSMutableList of categories so they cannot be selected again by another team.
 */
- (void) removeSelectedCategory:(NSString*) categoryName {
    
    if([self.categorySet count]>0){
        for(Category *category in self.categorySet){
            if([[category categoryName] isEqualToString:categoryName]){
                [self.categorySet removeObject:category];
                break;
            }
        }
    }
}


#pragma mark - Timer
- (void)startCountDown {
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

- (void)updateTime:(NSTimer *)timerParam {
    self.countDown--;
    if(self.countDown == 0) {
        [self clearCountDownTimer];
        //  Do rest of code here
    }
    
    self.countDownLabel.text = [NSString stringWithFormat:@"%d", self.countDown];
}

- (void)clearCountDownTimer {
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
    [self startCountDown];
    
}

- (BOOL) persistTeamDataToServiceForTeam:(Team*)team{
    
    NSString *teamPutURL = [NSString stringWithFormat:@"%@%@%@%@%@", @"http://instahackathon.elasticbeanstalk.com/hackathon/", self.currentEvent.hackathonEventId, @"/team/", team.teamId, @"/update"];
    
    NSURL *teamUpdateUrl = [NSURL URLWithString:teamPutURL];
    
    NSDictionary *teamDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          team.draftOrder,
                          @"draftOrder",
                          team.hackathonCategoryId,
                          @"hackathonCategoryId",
                          team.hackathonEventId,
                          @"hackathonEventId",
                          team.teamId,
                          @"teamId",
                          team.teamName,
                          @"teamName",
                          team.teamOptions,
                          @"teamOptions",
                          nil];
    
    //Convert object to data
    NSData *jsonData = [teamDic toJSON];
    //  Making a URL reqest with the created data
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:teamUpdateUrl];
    [request setHTTPMethod:@"PUT"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //  Sending request
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(urlConnection) {
        //  Getting the managed object context
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        return YES;
    }
    return NO;
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
