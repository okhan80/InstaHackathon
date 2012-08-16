//
//  NSDate+JSONDataRepresentation.m
//  InstaHackathon
//
//  Created by Omar Khan on 8/15/12.
//  Copyright (c) 2012 SPARC. All rights reserved.
//

#import "NSDate+JSONDataRepresentation.h"

@implementation NSDate (JSONDataRepresentation)

- (NSData *)JSONDataRepresentation
{
    return [[[NSNumber numberWithDouble:[self timeIntervalSince1970]] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
}

@end
