//
//  CommentModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface MomentModel : NSObject
@property (nonatomic) NSString *momentID;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *content;
@property (nonatomic) NSMutableArray *images;

+ (NSString *) stringOfTableName;
+ (int) countOfMoments;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (MomentModel *) momentWithRandomValues;
+ (NSArray *) arrayOfItemsFrom:(long) from to:(long) to;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) addImageModelsNumber:(int) number;
- (NSArray *) arrayOfInsertSqls;

@end
