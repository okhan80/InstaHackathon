//
//  MainViewController.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "MainViewController.h"
#import "TeamViewController.h"
#import "NSDictionary+JSONCategories.h"
#import "AppDelegate.h"
#import "Category.h"
#import "Team.h"
#import "TeamMember.h"


//  Macro to give back background queue
#define kBgQueueDefault dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kBGQueueHigh dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

//  URL to get data from
#define kHackathonDataURL @"http://instahackathon.elasticbeanstalk.com/hackathon/8a57f683392ae56c01392bbdb0de0008"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - Properties
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize hackathonEvent = _hackathonEvent;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  Setting up date formatter for conversion from string
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"MM/dd/yyyy";
    [self.dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //  Getting the managed object context
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    //  Pull data from context and then see if we need to pull from server

    [self setupFetchedResultsController];
    
    if(![[self.fetchedResultsController fetchedObjects] count] > 0) {
        //  There is nothing in the database so defaults will be inserted
        [self collectEventData];
    } else {
        self.hackathonEvent = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    }
    
    //  See if
    
    //  Downloading JSON data from URL in separate thread
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startDraftButtonPressed:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"teamView"]) {
        [segue.destinationViewController setCurrentEvent:self.hackathonEvent];
    }
}



#pragma mark - Insertion of Default Core Data
- (void)setupFetchedResultsController
{
    //  Getting the mission entity data
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    //  Sorting it
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    //  Fetch the data
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - Gathering JSON Data
#pragma mark - Event Data
- (void)collectEventData
{
    dispatch_async(kBGQueueHigh, ^ {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kHackathonDataURL]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedEventData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedEventData:(NSData *)responseData
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    self.hackathonEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                        inManagedObjectContext:self.managedObjectContext];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    [self.hackathonEvent safeSetValuesForKeysWithDictionary:json dateFormatter:dateFormatter];
    
    [self collectCategoryData];
    
    [self collectTeamData];
    
    //  Save the context
    [self.managedObjectContext save:&error];
}

#pragma mark - Category Data
- (void)collectCategoryData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/categories", kHackathonDataURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self fetchedCategoryData:data];
}

- (void)fetchedCategoryData:(NSData *)responseData
{
    //  Parse out the JSON data
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:kNilOptions
                                                      error:&error];
    for(NSDictionary *dict in json) {
        Category *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        NSDictionary *attributes = [[newCategory entity] attributesByName];
        for(NSString *attribute in attributes) {
            id value = [dict objectForKey:attribute];
            if(value == nil) {
                continue;
            } else if(value == (id)[NSNull null]) {
                continue;
            }
            [newCategory setValue:value forKey:attribute];
        }
        [self.hackathonEvent addCategoryListObject:newCategory];
    }
    
}

#pragma mark - Team Data
- (void)collectTeamData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/teams", kHackathonDataURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self fetchedTeamData:data];
}

- (void)fetchedTeamData:(NSData *)responseData
{
    //  Parse out the JSON data
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:kNilOptions
                                                      error:&error];
    
    for(NSDictionary *dict in json) {
        Team *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.managedObjectContext];
        NSDictionary *attributes = [[newTeam entity] attributesByName];
        for(NSString *attribute in attributes) {
            id value = [dict objectForKey:attribute];
            if(value == nil) {
                continue;
            } else if(value == (id)[NSNull null]) {
                continue;
            }
            [newTeam setValue:value forKey:attribute];
        }
        
        //  Adding the team member to the team
        NSSet *teamMemberSet = [NSSet setWithArray:[self fetchTeamMemberDataUsingTeamID:[dict objectForKey:@"teamId"]]];
        [newTeam addTeamMemberList:teamMemberSet];
        [self.hackathonEvent addTeamListObject:newTeam];
    }
}

- (NSMutableArray *)fetchTeamMemberDataUsingTeamID:(NSString *)teamID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", kHackathonDataURL, @"/team/", teamID, @"/members"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    //  Parse out the JSON data
    NSError *error = nil;
    NSMutableArray *teamMemberList = [NSMutableArray array];
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    for(NSDictionary *dict in json) {
        TeamMember *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"TeamMember" inManagedObjectContext:self.managedObjectContext];
        NSDictionary *attributes = [[newTeam entity] attributesByName];
        for(NSString *attribute in attributes) {
            id value = [dict objectForKey:attribute];
            if(value == nil) {
                continue;
            } else if(value == (id)[NSNull null]) {
                continue;
            }
            [newTeam setValue:value forKey:attribute];
        }
        
        [teamMemberList addObject:newTeam];
    }

    return teamMemberList;
}
@end
