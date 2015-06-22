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
#import "NSDictionary+Assemble.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation UserModel
@synthesize userID;
@synthesize name;
@synthesize avatar;
@synthesize desc;

#pragma mark - Construction

- (id)init
{
    self = [super self];
    if (self) {
        userID = [MyWeiboDefaults stringOfIdentifier:UserID];
    }
    return self;
}

#pragma mark - Class Methods Return Basic Data

+ (int)countOfUsers
{
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;

    return [dbManager countOfItemsNumberInTable:UserTableName];
}

+ (NSArray *)arrayOfProperties
{
    return @[UserID, UserName, UserAvatar, UserDescription];
}

+ (NSDictionary *)directoryOfPropertiesAndTypes
{
    NSArray *types = @[@"TEXT", @"TEXT", @"TEXT", @"TEXT"];

    return [NSDictionary dictionaryWithObjects:types
                                       forKeys:[UserModel arrayOfProperties]];
}

#pragma mark - Class Methods Return UserModel Instance

+ (UserModel *)userWithRandomValues
{
    UserModel *user = [[UserModel alloc] init];
    
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

#pragma mark - Extrive Data From UserModel Instance

- (NSDictionary *)dictionaryOfPropertiesAndValues
{
    NSArray *values = @[self.userID, self.name, self.avatar, self.desc];
    return [NSDictionary dictionaryWithObjects:values
                                       forKeys:[UserModel arrayOfProperties]];
}

#pragma mark - Overwirte AVObject Methods

- (void)saveInBackgroundWithBlock:(AVBooleanResultBlock)block
{
    DDLogDebug(@"New User:%@", [self dictionaryOfPropertiesAndValues]);
    [[self dictionaryOfPropertiesAndValues] eachPairDo:^(NSString *key, id value) {
        [self setObject:value forKey:key];
    }];
    [super saveInBackgroundWithBlock:block];
}

@end
