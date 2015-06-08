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
@property (nonatomic, strong) DBManager *databaseManager;
@end
