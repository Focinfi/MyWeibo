//
//  NewTableViewCell.h
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *weibo;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *weiboImages;

- (void) setAvatarAsRound;
- (void) setImages:(NSArray *) images;
- (void) addImages;
@end
