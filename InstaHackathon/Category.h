//
//  Category.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/16/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Team;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * hackathonCategoryId;
@property (nonatomic, retain) NSString * hackathonEventId;
@property (nonatomic, retain) Team *selectedTeam;
@property (nonatomic, retain) Event *theEvent;

@end
