//
//  NSDictionary+JSONCategories.h
//  InstaHackathon
//
//  Created by Omar Khan on 8/15/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONCategories)

+ (NSDictionary *)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress;
- (NSData *)toJSON;

@end
