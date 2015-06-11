//
//  ImageBrowser.h
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowser : NSObject
+(void)showImage:(UIImageView*)avatarImageView;
+(void)hideImage:(UITapGestureRecognizer*)tap;
@end
