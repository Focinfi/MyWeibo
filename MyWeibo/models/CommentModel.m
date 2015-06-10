
//
//  CommentModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentModel.h"
#import "Random.h"
#import "DBIdentifiers.h"
#import "ImageModel.h"
#import "MyWeiApp.h"
#import "UserModel.h"

@implementation CommentModel
@synthesize commentID;
@synthesize userID;
@synthesize content;

+ (NSString *) stringOfTableName
{
    return @"comments";
}

+ (int) countOfComments
{
    return [[MyWeiApp sharedManager].databaseManager countOfItemsNumberInTable:[CommentModel stringOfTableName]];
    
}

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects:@"comment_id", @"user_id", @"content", nil];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects:types forKeys:[CommentModel arrayOfProperties]];
}

+ (CommentModel *) commentWithRandomValues
{
    CommentModel *comment = [[CommentModel alloc] init];

//    NSArray *userIDs =
//        [[MyWeiApp sharedManager].databaseManager
//            arrayBySelect:[NSArray arrayWithObject:@"user_id"]
//                fromTable:[UserModel stringOfTableName]
//                    where:nil
//                     from:0
//                       to:[UserModel countOfUsers]];
//    
//    if ([userIDs count] > 0) {
//        comment.userID = userIDs[[Random randZeroToNum:(int)[userIDs count]]];
//
//    } else {
//        comment.userID = @"1";
//    }
    
    comment.userID = @"1";
    comment.content = [Random stringOfRandomWeiboSetencesCount:[Random randZeroToNum:3]];
    comment.commentID = [DBIdentifiers stringOfIdentifier:@"comment_id"];
    comment.images = [NSMutableArray array];
    [comment addImageModelsNumber:[Random randZeroToNum:4] + 2];

    return comment;
}

+ (NSArray *) arrayOfItemsFrom:(long) from to:(long) to
{
    NSMutableArray *data = [NSMutableArray array];
    
    NSArray *comments = [[MyWeiApp sharedManager].databaseManager arrayBySelect:[CommentModel arrayOfProperties] fromTable:[CommentModel stringOfTableName] where:nil from:from to:to];
    for (int i; i < [comments count]; i++) {
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) comments[i]];
        //set images
        NSString *commentID = [item objectForKey:@"comment_id"];
        NSArray *images =
            [[MyWeiApp sharedManager].databaseManager
                 arrayBySelect:[NSArray arrayWithObject:@"name"]
                     fromTable:[ImageModel stringOfTableName]
                         where:[NSDictionary dictionaryWithObject:commentID forKey:@"comment_id"]
                          from:0
                            to:[ImageModel countOfImages]];
        [item setObject:images forKey:@"images"];
        
        //set user info
//        NSString *userID = [item objectForKey:@"user_id"];
//        NSDictionary *user =
//            [[MyWeiApp sharedManager].databaseManager
//                dictionaryBySelect:[UserModel arrayOfProperties]
//                         fromTable:[UserModel stringOfTableName]
//                             where:[NSDictionary dictionaryWithObject:userID
//                                                               forKey:@"user_id"]];
        
        [item setObject:[[UserModel userWithRandomValues] dictionaryOfPropertiesAndValues] forKey:@"user"];
        
        [data addObject:item];
    }
    return data;
}


- (void) addImageModelsNumber:(int) number
{
    for (int i = 0; i < number; i++) {
        ImageModel *image = [ImageModel imageWithRandomValuesForCommentID:self.commentID];
        [self.images addObject:image];
    }
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:commentID, userID, content, nil]
                                       forKeys:[CommentModel arrayOfProperties]];
}

- (void) save
{
    [[MyWeiApp sharedManager].databaseManager
     insearItemsTableName:[CommentModel stringOfTableName]
     columns:[self dictionaryOfPropertiesAndValues]];
    
    for (int i; i < [self.images count]; i++) {
        NSLog(@"Insert Image %d" ,i);
        [self.images[i] save];
    }
}

@end
