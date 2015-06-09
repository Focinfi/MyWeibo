//
//  CommentModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *content;

+ (NSString *) stringOfCommentTableName;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (CommentModel *) commentWithRandomValues;
- (NSDictionary *) dictionaryOfPropertiesAndValues;
@end
