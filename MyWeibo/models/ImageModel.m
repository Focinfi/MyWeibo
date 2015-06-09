//
//  ImageModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "ImageModel.h"
#import "Random.h"

@implementation ImageModel
@synthesize name;
@synthesize commentID;

+ (NSString *) stringOfImageTableName
{
    return @"images";
}

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects: @"name", @"comment_id", nil];
}

+ (NSDictionary *) directoryOfPropertiesAndTypes
{
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects:[ImageModel arrayOfProperties] forKeys:types];
}

+ (ImageModel *) imageWithRandomValuesForCommentID:(NSString *) commentID;
{
    ImageModel *image = [[ImageModel alloc] init];
    image.commentID = commentID;

    if ([Random possibilityTenOfNum:5]) {
        if ([Random possibilityTenOfNum:5]) {
            image.name = @"Aoi1";
        } else {
            image.name = @"Aoi2";
        }
    } else {
        if ([Random possibilityTenOfNum:5]) {
            image.name = @"Anri1";
        } else {
            image.name = @"Anri2";
        }
    }
    return image;
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[ImageModel arrayOfProperties]
                                       forKeys:[NSArray arrayWithObjects:name, commentID, nil]];
}
@end
