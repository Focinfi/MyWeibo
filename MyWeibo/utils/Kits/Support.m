//
//  Support.m
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "Support.h"

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
@end

