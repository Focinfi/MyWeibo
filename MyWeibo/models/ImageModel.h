//
//  ImageModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ImageModel : NSObject<Model>
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *momentID;

+ (NSString *) stringOfTableName;
+ (int) countOfImages;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (ImageModel *) imageWithRandomValuesForCommentID:(NSString *) commentID;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) save;
@end
