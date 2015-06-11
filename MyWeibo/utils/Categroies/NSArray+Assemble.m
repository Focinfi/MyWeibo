//
//  NSArray+Assemble.m
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation NSArray (Assemble)
- (NSString *) stringByJoinSimpelyWithBoundary:(NSString *)boundary
{
    NSString *mapString = @"";
    
    for (int i = 0; i < self.count; i++) {
        mapString = [mapString stringByAppendingString: self[i]];
        if (i < self.count - 1) {
            mapString = [mapString stringByAppendingString: boundary];
        }
    }
    
    return mapString;
}

- (NSString *) stringByJoinEntierWithBoundary:(NSString *) boundary
{
    NSString *mapString = @"";
    NSLog(@"Boundary: %@", boundary);

    for (int i = 0; i < self.count; i++) {
        mapString = [mapString stringByAppendingString:[(NSString *)self[i] stringSwapWithBoundary:@"'"]];
        if (i < self.count - 1) {
            mapString = [mapString stringByAppendingString: boundary];
        }
    }
    
    return mapString;
}

- (NSArray *) arrayByMap:(id (^)(id)) map
{
    NSMutableArray *res = [NSMutableArray array];
    for (int i = 0; i < [self count]; i++) {
        id item = [self objectAtIndex:i];
        [res addObject: map(item)];
    }
    return res;
}

- (NSArray *) arrayBySelect:(BOOL (^)(id)) select
{
    NSMutableArray *res = [NSMutableArray array];
    for (int i = 0; i < [self count]; i++) {
        if (select(self[i])) {
            [res addObject:self[i]];
        }
    }
    return res;
}


@end
