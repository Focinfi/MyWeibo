//
//  LoginViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UserLoginViewController.h"
#import <AVOSCloud/AVUser.h>
#import "CocoaLumberjack.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+Format.h"
#import "Reachability.h"
#import "BasicTabViewController.h"
#import "Support.h"
#import "MyWeiboDefaults.h"
#import "MyWeiApp.h"
#import "UserEditViewController.h"

@interface UserLoginViewController (){
    enum Actions {
        LoginAction,
        RegisterAction
    };
    
    int currentAction;
}
@end

@implementation UserLoginViewController{
    NSString *userName;
    NSString *password;
}

#pragma mark - Construction

- (id)init
{
    self = [super init];
    if (self) {
        currentAction = LoginAction;
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [self setUIText];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Setup

- (void)setUIText
{
    self.loginButton.layer.cornerRadius = 5;
    self.userNameTextField.text = [MyWeiboDefaults stringOfKey:CurrentUser];
}

- (void)setInputValues
{
    userName = self.userNameTextField.text;
    password = self.passwordTestField.text;
}

#pragma mark - Button Actions

- (IBAction)exchange:(id)sender {
    switch (currentAction) {
        case LoginAction:
            currentAction = RegisterAction;
            self.userNameTextField.placeholder = @"你的用户名";
            [self.exchangeButton setTitle:@"已有账号？马上登录" forState:normal];
            [self.loginButton setTitle:@"注册" forState:normal];
            break;
            
        case RegisterAction:
            currentAction = LoginAction;
            self.userNameTextField.placeholder = @"用户名";
            [self.exchangeButton setTitle:@"注册一个" forState:normal];
            [self.loginButton setTitle:@"登录" forState:normal];
            break;
            
        default:
            break;
    }
}

- (IBAction)pushValues:(id)sender {
    [self setInputValues];
    DDLogDebug(@"userName: %@, password: %@", userName, password);
    
    if ([userName isBlank] || [password isBlank]) {
        [SVProgressHUD showErrorWithStatus:@"请填写完整"];
    } else if (![Support isReachabileToNet] ) {
        [SVProgressHUD showInfoWithStatus:AlertNotReachableNetWork];
    } else {
        switch (currentAction) {
            case LoginAction:
                [self loginUser];
                break;

            case RegisterAction:
                [self registerUser];
                break;

            default:
                break;
        }
    }
}

#pragma mark - User Login/Register

- (void)loginUser
{
    [SVProgressHUD showWithStatus:@"正在登录"];
    [AVUser logInWithUsernameInBackground:userName password:password block:^(AVUser *user, NSError *error) {
        if (![self hasError:error]) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [MyWeiboDefaults updateValue:@"YES" forKey:LoggedIn];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)registerUser
{
    [SVProgressHUD showWithStatus:@"正在注册"];

    AVUser *user= [AVUser user];
    user.username=userName;
    user.password=password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (![self hasError:error]) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [MyWeiboDefaults updateValue:@"YES" forKey:LoggedIn];
            [MyWeiboDefaults updateValue:userName forKey:CurrentUser];
            [self.navigationController pushViewController:[[UserEditViewController alloc] init] animated:YES];
            DDLogDebug(@"New User: %@", userName);
        }
    }];
}

#pragma mark - Error Filter

-(BOOL)hasError:(NSError *)error{
    if (error) {
        DDLogError(@"AVOS Error: %@", error);
        switch (error.code) {
            case 211:
                [SVProgressHUD showErrorWithStatus:@"用户还没有注册"];
                break;
                
            case 202:
                [SVProgressHUD showErrorWithStatus:@"用户已经被注册过了"];
                break;
                
            case 210:
                [SVProgressHUD showErrorWithStatus:@"用户名密码不匹配"];
                break;
                
            default:
                [SVProgressHUD showErrorWithStatus:@"网络出现异常，请重试"];
                break;
        }
        return YES;
    } else {
        return NO;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
