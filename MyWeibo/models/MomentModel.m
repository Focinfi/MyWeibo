
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
#import "Support.h"

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
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;

    return [dbManager countOfItemsNumberInTable:[MomentModel stringOfTableName]];
    
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
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;

    NSArray *moments = [dbManager arrayBySelect:[MomentModel arrayOfProperties] fromTable:[MomentModel stringOfTableName] where:nil from:from to:to];
    NSLog(@"Refresh Moments In MomentModel:%@", moments);
    for (NSDictionary *moment in moments) {
 
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) moment];
        //set images
        NSString *momentID = [item objectForKey:@"moment_id"];
        NSArray *images =
            [dbManager
                arrayOfAllBySelect:[NSArray arrayWithObject:@"name"]
                         fromTable:[ImageModel stringOfTableName]
                             where:[NSDictionary dictionaryWithObject:momentID forKey:@"moment_id"]];
        
        images = [images arrayByMap:(id)^(id item) {
            return [item objectForKey:@"name"];
        }];
        
        NSMutableArray *imagesArray = [NSMutableArray arrayWithArray:images];
        NSLog(@"Refresh Moments id %@ Images%@", momentID, imagesArray);
        
//        if ([images count] == 0) {
//            [imagesArray addObject:[NSString stringWithFormat:@"moment_id_%d", [Random randZeroToNum:4] + 1]];
//        }
        
        [item setObject:imagesArray forKey:@"images"];
        
        [item setObject:[[UserModel userWithRandomValues] dictionaryOfPropertiesAndValues] forKey:@"user"];
        
        [data addObject:item];
    }
    NSLog(@"Refresh Moments Data:%lu", [data count]);

    return data;
}


- (void) addImageModelsNumber:(int) number
{
    int rand = [Random randZeroToNum:4];
    for (int i = 0; i < number; i++) {
        int identifier = (rand + i)%4 + 1;
        ImageModel *image = [ImageModel imageWithIdentifier: identifier ForCommentID:self.momentID];
        [self.images addObject:image];
    }
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:momentID, userID, content, nil]
                                       forKeys:[MomentModel arrayOfProperties]];
}

- (NSArray *) arrayOfInsertSqls
{
    NSMutableArray *insertSqls = [NSMutableArray array];
    [insertSqls addObject:
     [Support stringOfInsertSqlWihtTableName:[MomentModel stringOfTableName]
                                     columns:self.dictionaryOfPropertiesAndValues]];
    
    for (ImageModel *image in self.images) {
        [insertSqls addObject:
         [Support stringOfInsertSqlWihtTableName:[ImageModel stringOfTableName]
                                         columns:image.dictionaryOfPropertiesAndValues]];
    }
    return insertSqls;
}

@end
