//
//  NewTableViewCell.m
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewTableViewCell.h"

@implementation NewTableViewCell

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize weiboImage;
@synthesize weiboImages;
- (void) setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

- (void) setImages:(NSArray *) images
{
    for (int i = 0; i < [images count] && i < 3; i++) {
        UIImageView * imageView = [weiboImages objectAtIndex:i];
        imageView.image = [UIImage imageNamed:images[i]];
    }
}

- (void) addImages
{
    UIImage *image = [UIImage imageNamed:@"Aoi1"];
    [self addSubview:(UIView *) image];
}
@end
