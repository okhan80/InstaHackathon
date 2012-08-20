//
//  HackathonResultsViewController.h
//  InstaHackathon
//
//  Created by Dayel Ostraco on 8/20/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HackathonResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

@end