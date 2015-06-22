//
//  UserViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/21.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "UserEditViewController.h"
#import "MyWeiboDefaults.h"
#import "MyWeiApp.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Support.h"
#import "NSString+Format.h"
#import "UserModel.h"
#import <AVOSCloud/AVOSCloud.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface UserEditViewController (){
    NSString *userAvatarImageString;
    int sheetTag;
}

@end

@implementation UserEditViewController

#pragma mark - Contruction

- (id)init
{
    self = [super init];
    if (self) {
        userAvatarImageString = @"";
        sheetTag = 255;
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [self setUIText];
    [self setAvatarImageRadius];
    [self setNavBar];
    [self setAvatarImageViewClickEvent];
    [super viewDidLoad];
}

#pragma mark - UI Setup

- (void)setUIText
{
    self.userNameLabel.text = [MyWeiboDefaults stringOfKey:CurrentUser];
}

- (void)setAvatarImageRadius
{
    self.userAvatarImageVIew.layer.masksToBounds = YES;
    self.userAvatarImageVIew.layer.cornerRadius = self.userAvatarImageVIew.bounds.size.width/2;
}

- (void)setNavBar
{
    self.title = @"填写用户信息";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateUserInfo)];
    rightButton.title = @"完成";
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)updateUserInfo
{
    NSString *userDescString = self.userDescTextFeild.text;
    if ([userDescString isBlank]) {
        [SVProgressHUD showErrorWithStatus:@"介绍一下自己吧"];
    } else if ([userAvatarImageString isBlank]) {
        [SVProgressHUD showInfoWithStatus:@"请添加头像"];
    } else {
        AVObject *user = [AVObject objectWithClassName:@"UserModel"];
        [user setObject:[MyWeiboDefaults stringOfKey:CurrentUser] forKey:UserName];
        [user setObject:userAvatarImageString forKey:UserAvatar];
        [user setObject:userDescString forKey:UserDescription];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                DDLogError(@"%@", error);
            } else {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                [MyWeiboDefaults updateValue:userAvatarImageString forKey:UserAvatarImage];
                DDLogDebug(@"upload User Avatar:%@", userAvatarImageString);
                [MyWeiboDefaults updateValue:userDescString forKey:UserDescription];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        DDLogDebug(@"NewLogUser:%@", userAvatarImageString);
    }
}

- (void)setAvatarImageViewClickEvent
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseUserAvatarImage)];
    self.userAvatarImageVIew.userInteractionEnabled = YES;
    [self.userAvatarImageVIew addGestureRecognizer:tap];
}

#pragma mark - TabBarItems Actions

- (void)choseUserAvatarImage
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = sheetTag;
    
    [sheet showInView:self.view];
}

#pragma mark actionsheet delegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == sheetTag) {
        
        NSUInteger sourceType = 0;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    return;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.userAvatarImageVIew.image = image;
    userAvatarImageString = [NSString stringWithFormat:@"%@_%@", UserAvatarImage, [MyWeiboDefaults stringOfIdentifier:UserAvatarImageID]];
    [Support saveImage:image withName:userAvatarImageString];
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
