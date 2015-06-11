//
//  ImageModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "ImageModel.h"
#import "Random.h"
#import "MyWeiApp.h"

@implementation ImageModel
@synthesize name;
@synthesize commentID;

+ (NSString *) stringOfTableName
{
    return @"images";
}

+ (int) countOfImages
{
    return [[MyWeiApp sharedManager].databaseManager countOfItemsNumberInTable:[ImageModel stringOfTableName]];
    
}

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects: @"name", @"comment_id", nil];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ImageModel arrayOfProperties]];
}

+ (ImageModel *) imageWithRandomValuesForCommentID:(NSString *) commentID;
{
    ImageModel *image = [[ImageModel alloc] init];
    image.commentID = commentID;

    if ([Random possibilityTenOfNum:5]) {
        if ([Random possibilityTenOfNum:5]) {
            image.name = @"weibo1";
        } else {
            image.name = @"weibo2";
        }
    } else {
        if ([Random possibilityTenOfNum:5]) {
            image.name = @"weibo3";
        } else {
            image.name = @"weibo4";
        }
    }
    return image;
}



- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:name, commentID, nil]
                                       forKeys:[ImageModel arrayOfProperties]];
}

- (void) save
{
    [[MyWeiApp sharedManager].databaseManager
     insearItemsTableName:[ImageModel stringOfTableName]
     columns:[self dictionaryOfPropertiesAndValues]];
}

@end
