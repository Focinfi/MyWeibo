
//
//  CommentModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MomentModel.h"
#import "Random.h"
#import "DBIdentifiers.h"
#import "ImageModel.h"
#import "MyWeiApp.h"
#import "UserModel.h"
#import "NSArray+Assemble.h"

@implementation MomentModel
@synthesize momentID;
@synthesize userID;
@synthesize content;

+ (NSString *) stringOfTableName
{
    return @"moments";
}

+ (int) countOfMoments
{
    return [[MyWeiApp sharedManager].databaseManager countOfItemsNumberInTable:[MomentModel stringOfTableName]];
    
}

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects:@"moment_id", @"user_id", @"content", nil];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects:types forKeys:[MomentModel arrayOfProperties]];
}

+ (MomentModel *) momentWithRandomValues
{
    MomentModel *comment = [[MomentModel alloc] init];

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
    comment.momentID = [DBIdentifiers stringOfIdentifier:@"moment_id"];
    comment.images = [NSMutableArray array];
    [comment addImageModelsNumber:[Random randZeroToNum:4] + 1];

    return comment;
}

+ (NSArray *) arrayOfItemsFrom:(long) from to:(long) to
{
    NSMutableArray *data = [NSMutableArray array];
    
    NSArray *comments = [[MyWeiApp sharedManager].databaseManager arrayBySelect:[MomentModel arrayOfProperties] fromTable:[MomentModel stringOfTableName] where:nil from:from to:to];
    for (int i; i < [comments count]; i++) {
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) comments[i]];
        //set images
        NSString *commentID = [item objectForKey:@"moment_id"];
        NSArray *images =
            [[MyWeiApp sharedManager].databaseManager
                 arrayOfAllBySelect:[NSArray arrayWithObject:@"name"]
                     fromTable:[ImageModel stringOfTableName]
                         where:[NSDictionary dictionaryWithObject:commentID forKey:@"moment_id"]];
             
        images = [images arrayByMap:(id)^(id item) {
            return [item objectForKey:@"name"];
        }];
        
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
        ImageModel *image = [ImageModel imageWithRandomValuesForCommentID:self.momentID];
        [self.images addObject:image];
    }
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:momentID, userID, content, nil]
                                       forKeys:[MomentModel arrayOfProperties]];
}

- (void) save
{
    [[MyWeiApp sharedManager].databaseManager
     insearItemsTableName:[MomentModel stringOfTableName]
     columns:[self dictionaryOfPropertiesAndValues]];
    
    for (int i; i < [self.images count]; i++) {
        NSLog(@"Insert Image %d" ,i);
        [self.images[i] save];
    }
}

@end
