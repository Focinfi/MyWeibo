//
//  LoginViewController.h
//  MyWeibo
//
//  Created by focinfi on 15/6/14.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTestField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
- (IBAction)exchange:(id)sender;

- (IBAction)pushValues:(id)sender;
@end
