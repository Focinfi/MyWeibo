//
//  NSArray+Assemble.h
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Assemble)

- (NSString *) joinWithBoundary:(NSString *) boundary;
- (NSString *) joinToStringWithBoundary:(NSString *) boundary;

@end
