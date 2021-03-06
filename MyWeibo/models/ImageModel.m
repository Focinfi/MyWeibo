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
#import "DBManager.h"

@implementation ImageModel
@synthesize name;
@synthesize momentID;

#pragma mark - Class Methods Return Basic Data

+ (int)countOfImages
{
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;
    return [dbManager countOfItemsNumberInTable:ImageTableName];    
}

+ (NSArray *)arrayOfProperties
{
    return @[ImageName, MomentID];
}

+ (NSDictionary *)directoryOfPropertiesAndTypes
{
    NSArray *types = @[@"TEXT", @"TEXT"];
    return [NSDictionary dictionaryWithObjects:types forKeys:[ImageModel arrayOfProperties]];
}

#pragma mark - Class Methods Return ImageModel Instance

+ (ImageModel *)imageWithIdentifier:(int) identifier ForCommentID:(NSNumber *) commentID
{
    ImageModel *image = [[ImageModel alloc] init];
    image.momentID = commentID;
    image.name = [NSString stringWithFormat:@"%@_%d", MomentImage, identifier];
    return image;
}

+ (ImageModel *)imageWithRandomValuesForCommentID:(NSNumber *) commentID
{
    ImageModel *image = [[ImageModel alloc] init];
    image.momentID = commentID;

    if ([Random possibilityTenOfNum:5]) {
        if ([Random possibilityTenOfNum:5]) {
            image.name = [NSString stringWithFormat:@"%@_%d", MomentImage, 1];
        } else {
            image.name = [NSString stringWithFormat:@"%@_%d", MomentImage, 2];
        }
    } else {
        if ([Random possibilityTenOfNum:5]) {
            image.name = [NSString stringWithFormat:@"%@_%d", MomentImage, 3];

        } else {
            image.name = [NSString stringWithFormat:@"%@_%d", MomentImage, 4];
        }
    }
    return image;
}

#pragma mark Instance Data

- (NSDictionary *)dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:@[name, momentID]
                                       forKeys:[ImageModel arrayOfProperties]];
}

@end
