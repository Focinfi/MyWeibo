//
//  DBIdentifiers.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWeiboDefaults : NSObject

+ (NSString *) stringOfIdentifier:(NSString *) identifier;
+ (NSNumber *) numberOfCurrentID:(NSString *) identifier;
+ (void) updateValue:(id) value forKey:(NSString *) key;
+ (NSString *) stringOfKey:(NSString *) key;
+ (id) objectOfKey:(NSString *) key;

@end
