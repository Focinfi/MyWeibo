//
//  Random.h
//  MyWeibo
//
//  Created by focinfi on 15/5/23.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Random : NSObject

+ (int) randZeroToNum:(int)num;
+ (BOOL) possibilityTenOfNum:(int)num;
+ (NSString *) stringOfRandomWeibo:(int)length;

@end
