//
//  NewsModel.h
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsModel : UITableViewController

@property (nonatomic) NSString *avatar;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *weibo;
@property (nonatomic) NSString *weiboImage;

+ (NSDictionary *) directoryForAtrributesAndTpyes;
+ (NSDictionary *) directoryForAtrributesAndNames;
+ (NewsModel *) newsWithRandomValues;

- (id) initNewsWithRandomValues;
- (NSDictionary *) dictionaryWithNewsPairs;

@end
