//
//  UserModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *avatar;
@property (nonatomic) NSString *desc;

+ (NSString *) stringOfTableName;
+ (int) countOfUsers;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (UserModel *) userWithRandomValues;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) save;

@end
