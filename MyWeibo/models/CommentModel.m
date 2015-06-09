
//
//  CommentModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
@synthesize userID;
@synthesize content;

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects: @"user_id", @"content", nil];
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[CommentModel arrayOfProperties]
                                       forKeys:[NSArray arrayWithObjects:userID, content, nil]];
}
@end
