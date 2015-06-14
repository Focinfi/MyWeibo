//
//  ImageModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ImageModel : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *momentID;

+ (NSString *) stringOfTableName;
+ (int) countOfImages;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (ImageModel *) imageWithRandomValuesForCommentID:(NSString *) commentID;
+ (ImageModel *) imageWithIdentifier:(int) identifier ForCommentID:(NSString *) commentID;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
@end
