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

//  Macro to give back background queue
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//  URL to get data from
#define kHackathonDataURL @"http://instahackathon.elasticbeanstalk.com/hackathon/8a57f683392ae56c01392bbdb0de0008"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - Properties
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

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
    //  Inserting default mission and event data
//    [self setupFetchedResultsController];
//    
//    if(![[self.fetchedResultsController fetchedObjects] count] > 0) {
//        //  There is nothing in the database so defaults will be inserted
//        MissionDatabase *missionData = [[MissionDatabase alloc] initManager];
//        [missionData loadAllMissions];
//        
//    }
    
    //  Downloading JSON data from URL in separate thread
    dispatch_async(kBgQueue, ^ {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/categories", kHackathonDataURL]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startDraftButtonPressed:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - JSON fetched data
- (void)fetchedData:(NSData *)responseData
{
    //  Parse out the JSON data
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    for(NSDictionary *dict in json) {
        Category *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
        [newCategory setValuesForKeysWithDictionary:dict];
    }
    //NSDictionary *firstValue = [json objectAtIndex:0];
    //  Store data as needed
    
}

#pragma mark - Insertion of Default Core Data
- (void)setupFetchedResultsController
{
    //  Getting the mission entity data
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Mission"];
    
    //  Sorting it
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    //  Fetch the data
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
}

@end
