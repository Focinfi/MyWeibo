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

/**
 *  Model const
 */
NSString *const DataBaseOrderASC = @"ASC";
NSString *const DataBaseOrderDESC = @"DESC";

NSString *const UserTableName = @"users";
NSString *const UserID = @"user_id";
NSString *const UserName = @"name";
NSString *const UserAvatar = @"avatar";
NSString *const UserDescription = @"description";
NSString *const CurrentUser = @"current_user";
NSString *const LoggedIn = @"NO";

NSString *const MomentTableName = @"moments";
NSString *const MomentID = @"moment_id";
NSString *const MomentUser = @"user";
NSString *const MomentContent = @"content";

NSString *const ImageTableName = @"images";
NSString *const MomentImage = @"moment_image";
NSString *const MomentImageId = @"moment_image_id";
NSString *const ImageName = @"name";

/**
 *  Resources identifier
 */
NSString *const MomentCellId = @"MomentCell";

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
        self.usesrDefaults = [NSUserDefaults standardUserDefaults];

    }
    return self;
}

@end
