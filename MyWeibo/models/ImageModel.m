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
#import "Support.h"

@implementation ImageModel
@synthesize name;
@synthesize momentID;

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
    return [NSArray arrayWithObjects: @"name", @"moment_id", nil];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ImageModel arrayOfProperties]];
}

+ (ImageModel *) imageWithIdentifier:(int) identifier ForCommentID:(NSString *) commentID
{
    ImageModel *image = [[ImageModel alloc] init];
    image.momentID = commentID;
    image.name = [NSString stringWithFormat:@"moment_id_%d", identifier];
    return image;
}

+ (ImageModel *) imageWithRandomValuesForCommentID:(NSString *) commentID
{
    ImageModel *image = [[ImageModel alloc] init];
    image.momentID = commentID;

    if ([Random possibilityTenOfNum:5]) {
        if ([Random possibilityTenOfNum:5]) {
            image.name = @"moment_id_1";
        } else {
            image.name = @"moment_id_2";
        }
    } else {
        if ([Random possibilityTenOfNum:5]) {
            image.name = @"moment_id_3";
        } else {
            image.name = @"moment_id_4";
        }
    }
    return image;
}



- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:name, momentID, nil]
                                       forKeys:[ImageModel arrayOfProperties]];
}

- (void) save
{
    [[MyWeiApp sharedManager].databaseManager
     insearItemsTableName:[ImageModel stringOfTableName]
     columns:[self dictionaryOfPropertiesAndValues]];
}

@end
