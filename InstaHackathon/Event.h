//
//  Event.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/16/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Team;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * hackathonEventId;
@property (nonatomic, retain) NSNumber * roundTimeSeconds;
@property (nonatomic, retain) NSNumber * categorySelections;
@property (nonatomic, retain) NSSet *categoryList;
@property (nonatomic, retain) NSSet *teamList;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addCategoryListObject:(Category *)value;
- (void)removeCategoryListObject:(Category *)value;
- (void)addCategoryList:(NSSet *)values;
- (void)removeCategoryList:(NSSet *)values;

- (void)addTeamListObject:(Team *)value;
- (void)removeTeamListObject:(Team *)value;
- (void)addTeamList:(NSSet *)values;
- (void)removeTeamList:(NSSet *)values;

@end

@interface Event (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

@end