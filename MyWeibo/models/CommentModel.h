//
//  CommentModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface CommentModel : NSObject<Model>
@property (nonatomic) NSString *commentID;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *content;
@property (nonatomic) NSMutableArray *images;

+ (NSString *) stringOfTableName;
+ (int) countOfComments;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (CommentModel *) commentWithRandomValues;
+ (NSArray *) arrayOfItemsFrom:(long) from to:(long) to;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) addImageModelsNumber:(int) number;
- (void) save;

@end
