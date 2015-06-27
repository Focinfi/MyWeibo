//
//  CommentDetailViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MomentDetailViewController.h"
#import "ImageBrowser.h"
#import "Support.h"
#import "MyWeiApp.h"

@interface MomentDetailViewController (){
    NSDictionary *userInfo;
    int padding;
    int mommentContentHeight;
    int mommentScrollWidth;
    int mommentScrollHeight;
}

@end

@implementation MomentDetailViewController
@synthesize avatar;
@synthesize userName;
@synthesize userDescription;
@synthesize mommentScrollView;
@synthesize mommentData;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [self initValue];
    [self setUI];
    [super viewDidLoad];
}

#pragma mark Init Values

- (void)initValue
{
    padding = 10;
    mommentScrollWidth = 250;
    userInfo = [self.mommentData objectForKey:MomentUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UI Setup

- (void)setUI
{
    [self setAvatarAsRound];
    [self setNameAndDescription];
    [self setCommentContent];
    [self setImages];
    [self setCommentScrollView];
    
    NSLog(@"Detail Data: %@", [mommentData objectForKey:MomentContent]);
}

- (void)setAvatarAsRound
{
    self.avatar.image = [[UIImage alloc]
                         initWithContentsOfFile:
                         [Support stringOfFilePathForImageName:[userInfo objectForKey:UserAvatar]]];
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

- (void)setNameAndDescription
{
    self.title = @"Moment";
    self.userName.text = [userInfo objectForKey:UserName];
    self.userDescription.text = [userInfo objectForKey:UserDescription];
}

- (void)setCommentScrollView
{
    self.mommentScrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.8];
    self.mommentScrollView.contentSize = CGSizeMake(mommentScrollWidth, mommentScrollHeight);
    self.mommentScrollView.layer.masksToBounds = YES;
    self.mommentScrollView.layer.cornerRadius = 8;
}

- (void)setCommentContent
{
    NSString *contentText = [self.mommentData objectForKey:MomentContent];
    UILabel *content = [[UILabel alloc] init];
    content.numberOfLines = [contentText length]/10 + 1;
    mommentContentHeight = (int)content.numberOfLines * 15 + padding;
    mommentScrollHeight += mommentContentHeight + padding;
    content.frame = CGRectMake(padding, 0, mommentScrollWidth - padding, mommentContentHeight);
    content.text = contentText;
    [self.mommentScrollView addSubview:content];
}

- (void)setImages
{
    NSArray *images = [self.mommentData objectForKey:ImageTableName];
    NSLog(@"Images Count: %lu", (unsigned long)[images count]);
    NSLog(@"Image:%@", images);
    for (NSString *imageName in images) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [[UIImage alloc]
                           initWithContentsOfFile:
                           [Support stringOfFilePathForImageName:imageName]];
        
        float imageHeight = (mommentScrollWidth - padding) * [Support proportionOfHeigthToWidth:imageView.image.size];
        
        imageView.frame = CGRectMake(padding, mommentScrollHeight, mommentScrollWidth - padding, imageHeight);
        
        mommentScrollHeight += imageHeight + padding;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
        
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        [self.mommentScrollView addSubview:imageView];
    }
}

#pragma mark - Gesture Actions

- (void)magnifyImage:(UITapGestureRecognizer *) gestureRecognizer
{
    [ImageBrowser showImage:(UIImageView *)[gestureRecognizer view]];
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
