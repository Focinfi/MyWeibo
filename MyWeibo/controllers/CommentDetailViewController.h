//
//  CommentDetailViewController.h
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentTableViewController.h"
@interface CommentDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *commentScrollView;

@property (nonatomic) CommentTableViewController *commentTableViewController;

@end
