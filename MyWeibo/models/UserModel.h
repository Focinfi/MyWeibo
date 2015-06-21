//
//  UserModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserModel : AVObject
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *avatar;
@property (nonatomic) NSString *desc;

+ (int) countOfUsers;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (UserModel *) userWithRandomValues;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) saveInBackgroundWithBlock:(AVBooleanResultBlock)block;

@end
