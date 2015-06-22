//
//  NSString+Format.m
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

#pragma mark - String Decrator

- (NSString *)stringSwapWithBoundary: (NSString *)boundary
{
    NSString *res = boundary;
    res = [res stringByAppendingString:self];
    res = [res stringByAppendingString:boundary];
    return res;
}

#pragma mark - String Detector

- (BOOL)isBlank
{
    return self.length == 0;
}

- (BOOL)isYES
{
    return [self isEqualToString:@"YES"];
}

@end
