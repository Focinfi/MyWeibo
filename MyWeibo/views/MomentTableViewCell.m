//
//  NewTableViewCell.m
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MomentTableViewCell.h"
#import "Support.h"

@implementation MomentTableViewCell

@synthesize avatar;
@synthesize name;
@synthesize description;
@synthesize weibo;
@synthesize weiboImages;

#pragma mark - UI Config

- (void)setAvatarAsRound
{
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

#pragma mark - Image Insertor

- (void)setImages:(NSArray *) images
{
    for (int i = 0; i < 3; i++) {
        if (i < [images count]) {
            UIImageView * imageView = [weiboImages objectAtIndex:i];
            NSLog(@"Images' File Path: %@", images[i]);
            imageView.image = [[UIImage alloc]
                               initWithContentsOfFile:
                               [Support stringOfFilePathForImageName:images[i]]];
        } else {
            UIImageView * imageView = [weiboImages objectAtIndex:i];
            imageView.image = nil;
        }
       
    }
}

@end
