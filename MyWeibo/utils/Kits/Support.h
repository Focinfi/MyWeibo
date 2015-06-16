//
//  Support.h
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Support : NSObject
+ (float) proportionOfHeigthToWidth:(CGSize) size;
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
+ (NSString *) stringOfFilePathForImageName:(NSString *) imageName;
+ (NSString *) stringOfInsertSqlWihtTableName:(NSString *)name columns:(NSDictionary *)columns;
+ (BOOL) isReachabileToNet;
@end
