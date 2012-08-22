//
//  MainViewController.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/14/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "Event.h"
#import "NewsTickerView.h"

@interface MainViewController : UIViewController <NewsTickerViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) Event *hackathonEvent;


//  Displaying the news ticker
//@property (weak, nonatomic) IBOutlet NewsTickerView *tickerView;
@property (strong, nonatomic) NSArray *tickerItems;
@property (weak, nonatomic) IBOutlet NewsTickerView *tickerView;

@end
