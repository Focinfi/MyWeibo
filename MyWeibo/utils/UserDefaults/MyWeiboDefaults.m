//
//  DBIdentifiers.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MyWeiboDefaults.h"
#import "MyWeiApp.h"

@implementation MyWeiboDefaults
+ (NSString *) stringOfIdentifier:(NSString *) identifier
{
    NSString * newIdentifierString =[NSString stringWithFormat:@"%d",
                                     [[MyWeiboDefaults numberOfCurrentID:identifier] intValue] + 1];
    [MyWeiboDefaults updateValue:newIdentifierString forKey:identifier];

    return newIdentifierString;
}

+ (NSNumber *) numberOfCurrentID:(NSString *) identifier
{
    NSString *number = [[MyWeiApp sharedManager].usesrDefaults stringForKey:identifier];

    if (number == nil) {
        number = @"10";
    }
    return [NSNumber numberWithInteger:[number intValue]];
}

+ (void) updateValue:(NSString *) value forKey:(NSString *) key
{
    [[MyWeiApp sharedManager].usesrDefaults setObject:value forKey:key];
}

+ (NSString *) stringOfKey:(NSString *) key
{
    NSString *value = [[MyWeiApp sharedManager].usesrDefaults objectForKey:key];
    if (value == nil) {
        value = @"";
    }
    return value;
}

@end