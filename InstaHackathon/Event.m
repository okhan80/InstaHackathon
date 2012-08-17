//
//  Event.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/16/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "Event.h"
#import "Category.h"
#import "Team.h"


@implementation Event

@dynamic eventDate;
@dynamic eventName;
@dynamic hackathonEventId;
@dynamic roundTimeSeconds;
@dynamic categorySelections;
@dynamic categoryList;
@dynamic teamList;

@end

@implementation Event (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for(NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        if(value == nil) {
            continue;
        }
        
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSNumber class]]) && dateFormatter != nil) {
            NSTimeInterval dateInSecondsPassed1970 = [value doubleValue] / 1000;
            value = [NSDate dateWithTimeIntervalSince1970:dateInSecondsPassed1970];
        }
        [self setValue:value forKey:attribute];
    }
}

@end