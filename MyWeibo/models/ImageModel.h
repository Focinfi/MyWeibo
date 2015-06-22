//
//  ImageModel.h
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageModel : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *momentID;

+ (int) countOfImages;
+ (NSArray *) arrayOfProperties;
+ (NSDictionary *) directoryOfPropertiesAndTypes;
+ (ImageModel *) imageWithRandomValuesForCommentID:(NSNumber *) commentID;
+ (ImageModel *) imageWithIdentifier:(int) identifier ForCommentID:(NSNumber *) commentID;

- (NSDictionary *) dictionaryOfPropertiesAndValues;
@end
