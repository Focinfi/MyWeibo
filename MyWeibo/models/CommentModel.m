
//
//  CommentModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentModel.h"
#import "Random.h"

@implementation CommentModel
@synthesize userID;
@synthesize content;

+ (NSString *) stringOfCommentTableName
{
    return @"comments";
}

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects: @"user_id", @"content", nil];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects:[CommentModel arrayOfProperties] forKeys:types];
}

+ (CommentModel *) commentWithRandomValues
{
    CommentModel *comment = [[CommentModel alloc] init];
    comment.content = [Random stringOfRandomWeiboSetencesCount:[Random randZeroToNum:3]];
    return comment;
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[CommentModel arrayOfProperties]
                                       forKeys:[NSArray arrayWithObjects:userID, content, nil]];
}
@end
