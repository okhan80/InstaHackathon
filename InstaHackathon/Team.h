//
//  Team.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/17/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Event, TeamMember;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * draftOrder;
@property (nonatomic, retain) NSString * hackathonCategoryId;
@property (nonatomic, retain) NSString * hackathonEventId;
@property (nonatomic, retain) NSString * teamId;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSNumber * teamOptions;
@property (nonatomic, retain) Category *chosenCategory;
@property (nonatomic, retain) NSSet *teamMemberList;
@property (nonatomic, retain) Event *theEvent;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addTeamMemberListObject:(TeamMember *)value;
- (void)removeTeamMemberListObject:(TeamMember *)value;
- (void)addTeamMemberList:(NSSet *)values;
- (void)removeTeamMemberList:(NSSet *)values;

@end
