//
//  Support.m
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "Support.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"

@implementation Support
+ (float) proportionOfHeigthToWidth:(CGSize) size
{
    return size.height / size.width;
}

+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [Support stringOfFilePathForImageName:imageName];
    [imageData writeToFile:fullPath atomically:YES];
}

+ (NSString *) stringOfFilePathForImageName:(NSString *) imageName
{
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSLog(@"Image File Path: %@", fullPath);
    return fullPath;
}

#pragma mark - Make Insert SQL

+ (NSString *) stringOfInsertSqlWihtTableName:(NSString *)name columns:(NSDictionary *)columns
{
    NSArray *keys = [columns allKeys];
    NSArray *values = [columns allValues];
    NSString *insertSql = [NSString stringWithFormat:
                           @"INSERT INTO %@ (%@) VALUES (%@)",
                           name, [keys stringByJoinEntierWithBoundary:@","], [values stringByJoinEntierWithBoundary:@","]];
    return insertSql;
}
@end

