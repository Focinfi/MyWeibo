//
//  MyWeiApp.m
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MyWeiApp.h"
#import "DBManager.h"

@implementation MyWeiApp

NSString *const UserTableName = @"users";
NSString *const UserID = @"user_id";
NSString *const UserName = @"name";
NSString *const UserAvatar = @"avatar";
NSString *const UserDescription = @"description";

NSString *const ImageTableName = @"images";
NSString *const ImageName = @"name";

NSString *const MomentTableName = @"moments";
NSString *const MomentContent = @"content";


@synthesize dbManager;
+ (MyWeiApp *)sharedManager
{
    static MyWeiApp *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

@end
