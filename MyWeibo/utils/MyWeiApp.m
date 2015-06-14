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
