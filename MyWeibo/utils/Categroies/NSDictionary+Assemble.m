//
//  NSDictionary+Assemble.m
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NSDictionary+Assemble.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation NSDictionary (Assemble)
- (NSString *) stringByJoinEntierWithBoundary:(NSString *)boundary
{
    NSArray *keys = [self allKeys];
    NSLog(@"Columns1: %@", keys);
    
    NSString *mapString;
    NSMutableArray *pairs = [NSMutableArray array];
    
    for (NSString *key in keys) {
        NSString * type = [self objectForKey:key];
        NSString *assemble = key;
        assemble = [assemble stringByAppendingFormat:@"=%@", [type stringSwapWithBoundary:@"'"]];
        [pairs addObject:assemble];
    }
    
    mapString = [pairs stringByJoinSimpelyWithBoundary:boundary];
    return mapString;
}
@end
