//
//  DBIdentifiers.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DBIdentifiers.h"
#import "MyWeiApp.h"

@implementation DBIdentifiers
+ (NSString *) stringOfIdentifier:(NSString *) identifier
{
    NSString * newIdentifierString =[NSString stringWithFormat:@"%d",
                                     [[DBIdentifiers numberOfCurrentID:identifier] intValue] + 1];
    [DBIdentifiers updateIdentifier:identifier newValue:newIdentifierString];
    
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

+ (void) updateIdentifier:(NSString *) identifier newValue:(NSString *) value
{
    [[MyWeiApp sharedManager].usesrDefaults setObject:value forKey:identifier];
}
@end
