//
//  ImageModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel
@synthesize name;
@synthesize commentID;

+ (NSArray *) arrayOfProperties
{
    return [NSArray arrayWithObjects: @"name", @"comment_id", nil];
}

- (NSDictionary *) dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:[ImageModel arrayOfProperties]
                                       forKeys:[NSArray arrayWithObjects:name, commentID, nil]];
}
@end
