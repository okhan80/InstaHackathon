//
//  TeamMember.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/16/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface TeamMember : NSManagedObject

@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * teamId;
@property (nonatomic, retain) NSString * teamMemberId;
@property (nonatomic, retain) Team *theTeam;

@end
