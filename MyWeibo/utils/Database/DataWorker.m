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
#import "DBIdentifiers.h"

@implementation DataWorker
+ (void) insertBasicDataWihtNumber:(int) number
{
    if ([MomentModel countOfMoments] < number) {
        [DataWorker saveBasicImages];
        for (int i = 0; i < number; i++) {
            [[MomentModel momentWithRandomValues] save];
        }
    }

}

+ (void) saveBasicImages
{
    for (int i = 0; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"moment_id_%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [Support saveImage:image withName:imageName];
        NSLog(@"UIImage:%@", imageName);
    }
}
@end
