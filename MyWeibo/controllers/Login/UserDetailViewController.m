//
//  UserDetailViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/21.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UserDetailViewController.h"
#import <AVOSCloud/AVUser.h>
#import "LoginViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "MyWeiApp.h"
#import "MyWeiboDefaults.h"
#import "NSString+Format.h"
#import "Support.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"我的信息"];
    [self setImageViewRadius];
    [self navigateToLoginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)navigateToLoginView
{
    DDLogDebug(@"LoggedIn:%@", [MyWeiboDefaults stringOfKey:LoggedIn]);
    if ([[MyWeiboDefaults stringOfKey:LoggedIn] isYES]) {
        [self setUIText];
    } else {
        [self clearUIText];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"还没登录" message:@"现在就去登录页面" delegate:self cancelButtonTitle:CancelBtnTitle otherButtonTitles:GotoLoginBtnTitle, nil];
        
        [alert show];
    }
}

- (void)setImageViewRadius
{
    self.userAvatarImageView.layer.masksToBounds = YES;
    self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.bounds.size.width/2;
    
    self.logOutButton.layer.cornerRadius = 5;
}

- (void)setUIText
{
    self.userAvatarImageView.image =
        [[UIImage alloc] initWithContentsOfFile:
            [Support stringOfFilePathForImageName:
                [MyWeiboDefaults stringOfKey:UserAvatarImage]]];
    DDLogDebug(@"User Avatar:%@", [MyWeiboDefaults stringOfKey:UserAvatarImage]);
    self.userNameLabel.text = [MyWeiboDefaults stringOfKey:CurrentUser];
    self.userDescLabel.text = [MyWeiboDefaults stringOfKey:UserDescription];
    self.logOutButton.hidden = NO;
}

- (void)clearUIText
{
    self.userAvatarImageView.image = [UIImage imageNamed:@"UserAvatar"];
    self.userNameLabel.text = @"用户名";
    self.userDescLabel.text = @"个性签名";
    self.logOutButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logOutButtonAction:(id)sender {
    [AVUser logOut];
    [MyWeiboDefaults updateValue:@"NO" forKey:LoggedIn];
    [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}

#pragma mark - Alert Actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:CancelBtnTitle]) {
        self.tabBarController.selectedIndex = 0;
    } else if ([btnTitle isEqualToString:GotoLoginBtnTitle] ) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
@end
