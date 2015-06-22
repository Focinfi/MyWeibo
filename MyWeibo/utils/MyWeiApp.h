//
//  MyWeiApp.h
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface MyWeiApp : NSObject
+ (MyWeiApp *)sharedManager;

@property (nonatomic, strong) NSUserDefaults *usesrDefaults;
@property (nonatomic, strong) DBManager *dbManager;

/**
 *  Model const
 */
extern NSString *const DataBaseOrderASC;;
extern NSString *const DataBaseOrderDESC;

extern NSString *const UserTableName;
extern NSString *const UserID;
extern NSString *const UserName;
extern NSString *const UserAvatar;
extern NSString *const UserDescription;
extern NSString *const CurrentUser;
extern NSString *const LoggedIn;

extern NSString *const MomentTableName;
extern NSString *const MomentID;
extern NSString *const MomentUser;
extern NSString *const MomentContent;

extern NSString *const ImageTableName;
extern NSString *const MomentImageId;
extern NSString *const UserAvatarImage;
extern NSString *const UserAvatarImageID;
extern NSString *const MomentImage;
extern NSString *const ImageName;

/**
 *  Resources idenditifier
 */
extern NSString *const MomentCellId;

/**
 *  Alert
 */
extern NSString *const AlertNotReachableNetWork;
extern NSString *const CancelBtnTitle;
extern NSString *const GotoLoginBtnTitle;

@end
