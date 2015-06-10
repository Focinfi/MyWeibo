//
//  Model.h
//  MyWeibo
//
//  Created by focinfi on 15/6/10.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Model <NSObject>
+ (NSString *) stringOfTableName;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) save;

@end
