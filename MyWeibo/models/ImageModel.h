//
//  ImageModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *commentID;

+ (NSString *) stringOfImageTableName;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (ImageModel *) imageWithRandomValuesForCommentID:(NSString *) commentID;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
@end
