//
//  DataWorker.m
//  MyWeibo
//
//  Created by focinfi on 15/6/10.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DataWorker.h"
#import "MyWeiApp.h"
#import "DBManager.h"
#import "MomentModel.h"
#import "UserModel.h"
#import "Support.h"
#import "MyWeiboDefaults.h"

@implementation DataWorker
+ (void) insertBasicDataWihtNumber:(int) number
{
    if ([MomentModel countOfMoments] < number) {
        [MyWeiboDefaults updateValue:@"NO" forKey:@"user_moment"];
        [DataWorker saveBasicImages];
        NSMutableArray *sqls = [NSMutableArray array];
        for (int i = 0; i < number; i++) {
            [sqls addObjectsFromArray:[[MomentModel momentWithRandomValues] arrayOfInsertSqls]];
        }
        [[MyWeiApp sharedManager].dbManager excuteSQLs:sqls];
    }
}

+ (void) saveBasicImages
{
    for (int i = 0; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"moment_image_%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [Support saveImage:image withName:imageName];
        NSLog(@"UIImage:%@", imageName);
    }
}
@end
