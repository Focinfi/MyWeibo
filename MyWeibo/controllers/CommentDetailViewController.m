//
//  CommentDetailViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/11.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "ImageBrowser.h"
#import "Support.h"

@interface CommentDetailViewController (){
    NSDictionary *commentData;
    NSDictionary *userInfo;
    int padding;
    int commentContentHeight;
    int commentScrollWidth;
    int commentScrollHeight;
}

@end

@implementation CommentDetailViewController
@synthesize avatar;
@synthesize userName;
@synthesize userDescription;
@synthesize commentScrollView;
@synthesize commentTableViewController;

- (void)viewDidLoad {
    
    [self initValue];
    [self setUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark Init Values

- (void) initValue
{
    padding = 10;
    commentScrollWidth = 250;
    commentData = self.commentTableViewController.clickedCellData;
    userInfo = [commentData objectForKey:@"user"];
}

#pragma mark Init UI

- (void) setUI
{
    [self setAvatarAsRound];
    [self setNameAndDescription];
    [self setCommentContent];
    [self setImages];
    [self setCommentScrollView];
}

- (void) setAvatarAsRound
{
    self.avatar.image = [UIImage imageNamed:[userInfo objectForKey:@"avatar"]];
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.bounds.size.width/2;
}

- (void) setNameAndDescription
{
    self.userName.text = [userInfo objectForKey:@"name"];
    self.userDescription.text = [userInfo objectForKey:@"description"];
}

- (void) setCommentScrollView
{
    self.commentScrollView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.8];
    self.commentScrollView.contentSize = CGSizeMake(commentScrollWidth, commentScrollHeight);
    self.commentScrollView.layer.masksToBounds = YES;
    self.commentScrollView.layer.cornerRadius = 8;
}

- (void) setCommentContent
{
    NSString *contentText = [commentData objectForKey:@"content"];
    UILabel *content = [[UILabel alloc] init];
    content.numberOfLines = [contentText length]/10;
    commentContentHeight = (int)content.numberOfLines * 16;
    commentScrollHeight += commentContentHeight + padding;
    content.frame = CGRectMake(padding, 0, commentScrollWidth - padding, commentContentHeight);
    content.text = contentText;
    [self.commentScrollView addSubview:content];
}

- (void) setImages
{
    NSArray *images = [commentData objectForKey:@"images"];
    for (int i = 0; i < [images count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:images[i]];
        
        float imageHeight = (commentScrollWidth - padding) * [Support proportionOfHeigthToWidth:imageView.image.size];
        
        imageView.frame = CGRectMake(padding, commentScrollHeight, commentScrollWidth - padding, imageHeight);
        
        commentScrollHeight += imageHeight + padding;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
        
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        [self.commentScrollView addSubview:imageView];
    }
}

- (void)magnifyImage:(UITapGestureRecognizer *) gestureRecognizer
{
    [ImageBrowser showImage:(UIImageView *)[gestureRecognizer view]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
