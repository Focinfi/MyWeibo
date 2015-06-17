//
//  UserModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UserModel.h"
#import "MyWeiApp.h"
#import "Random.h"
#import "MyWeiboDefaults.h"

@implementation UserModel
@synthesize userID;
@synthesize name;
@synthesize avatar;
@synthesize desc;

+ (NSString *) stringOfTableName
{
    return @"users";
}

+ (int) countOfUsers
{
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;

    return [dbManager countOfItemsNumberInTable:[UserModel stringOfTableName]];
}

+ (NSArray *) arrayOfProperties
{
    return @[@"user_id", @"name", @"avatar", @"description"];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = @[@"TEXT", @"TEXT", @"TEXT", @"TEXT"];

    return [NSDictionary dictionaryWithObjects:types
                                       forKeys:[UserModel arrayOfProperties]];
}
+ (UserModel *) userWithRandomValues
{
    UserModel *user = [[UserModel alloc] init];
    user.userID = [MyWeiboDefaults stringOfIdentifier:@"user_id"];
    
    if ([Random possibilityTenOfNum:5]) {
        user.name = @"苍井优";
        user.desc = @"森系日本女演员";
        if ([Random possibilityTenOfNum:5]) {
            user.avatar = @"Aoi1";
        } else {
            user.avatar = @"Aoi2";
        }
    } else {
        user.name = @"熊杏木里";
        user.desc = @"治愈系女歌手";
        if ([Random possibilityTenOfNum:5]) {
            user.avatar = @"Anri1";
        } else {
            user.avatar = @"Anri2";
        }
    }

    return user;
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    NSArray *values = @[userID, name, avatar, desc];
    return [NSDictionary dictionaryWithObjects:values
                                       forKeys:[UserModel arrayOfProperties]];
}

@end
