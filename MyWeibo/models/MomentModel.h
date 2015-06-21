//
//  CommentModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MomentModel : AVObject
@property (nonatomic) NSNumber *momentID;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *content;
@property (nonatomic) NSMutableArray *images;

+ (int) countOfMoments;
+ (NSArray *) arrayOfProperties;
+ (NSArray *) arrayOfObjects:(NSArray *) objects;
+ (NSDictionary *) dictionaryOfObject:(id) object;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (MomentModel *) momentWithRandomValues;
+ (NSArray *) arrayOfItemsFrom:(long) from to:(long) to;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
- (void) addImageModelsNumber:(int) number;
- (NSArray *) arrayOfInsertSqls;

- (void) saveInBackgroundWithBlock:(AVBooleanResultBlock)block;
@end
