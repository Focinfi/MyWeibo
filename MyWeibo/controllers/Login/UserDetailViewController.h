//
//  UserDetailViewController.h
//  MyWeibo
//
//  Created by focinfi on 15/6/21.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;

- (IBAction)logOutButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@end
