//
//  DBIdentifiers.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBIdentifiers : NSObject
+ (NSString *) stringOfIdentifier:(NSString *) identifier;
+ (NSNumber *) numberOfCurrentID:(NSString *) identifier;
+ (void) updateIdentifier:(id) identifier newValue:(NSString *) value;

@end
