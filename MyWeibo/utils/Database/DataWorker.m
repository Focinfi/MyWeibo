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
#import "CommentModel.h"
#import "UserModel.h"

@implementation DataWorker
+ (void) insertBasicDataWihtNumber:(int) number
{
    if ([CommentModel countOfComments] < number) {
        for (int i = 0; i < number; i++) {
            [[CommentModel commentWithRandomValues] save];
        }
    }

}

@end
