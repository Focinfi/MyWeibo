//
//  BasicTabViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/16.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "BasicTabViewController.h"

@interface BasicTabViewController ()

@end

@implementation BasicTabViewController

- (void)viewDidLoad {
    [self setTab];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void) setTab{

    [self setSelectedIndex:0];
    //
    UITabBar *tabBar = self.tabBar;
    [tabBar setTintColor: [UIColor greenColor]];
    tabBar.translucent = NO;
    
    //UITabBarItem
    UITabBarItem *tab1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tab2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tab3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tab4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tab5 = [tabBar.items objectAtIndex:4];
    
    UIImage *tab1Image = [UIImage imageNamed:@"Home"];
    UIImage *scaledTab1Image = [UIImage imageWithCGImage: [tab1Image CGImage] scale:(tab1Image.scale * 4) orientation:(tab1Image.imageOrientation)];
    
    UIImage *tab1SelectedImage = [UIImage imageNamed:@"Home"];
    UIImage *scaledTab1SelectedImage = [UIImage imageWithCGImage: [tab1SelectedImage CGImage] scale:(tab1SelectedImage.scale * 4) orientation:(tab1SelectedImage.imageOrientation)];
    (void)[tab1 initWithTitle:@"主页" image:scaledTab1Image selectedImage:scaledTab1SelectedImage];
    
    UIImage *tab2Image = [UIImage imageNamed:@"Message"];
    UIImage *scaledTab2Image = [UIImage imageWithCGImage: [tab2Image CGImage] scale:(tab2Image.scale * 4) orientation:(tab2Image.imageOrientation)];
    
    UIImage *tab2SelectedImage = [UIImage imageNamed:@"Message"];
    UIImage *scaledTab2SelectedImage = [UIImage imageWithCGImage: [tab2SelectedImage CGImage] scale:(tab2SelectedImage.scale * 4) orientation:(tab2SelectedImage.imageOrientation)];
    (void)[tab2 initWithTitle:@"消息" image:scaledTab2Image selectedImage:scaledTab2SelectedImage];
    
    UIImage *tab3Image = [UIImage imageNamed:@"Add"];
    UIImage *scaledTab3Image = [UIImage imageWithCGImage: [tab3Image CGImage] scale:(tab3Image.scale * 4) orientation:(tab3Image.imageOrientation)];
    
    UIImage *tab3SelectedImage = [UIImage imageNamed:@"Add"];
    UIImage *scaledTab3SelectedImage = [UIImage imageWithCGImage: [tab3SelectedImage CGImage] scale:(tab3SelectedImage.scale * 4) orientation:(tab3SelectedImage.imageOrientation)];
    (void)[tab3 initWithTitle:@"添加" image:scaledTab3Image selectedImage:scaledTab3SelectedImage];
    
    UIImage *tab4Image = [UIImage imageNamed:@"Search"];
    UIImage *scaledTab4Image = [UIImage imageWithCGImage: [tab4Image CGImage] scale:(tab4Image.scale * 4) orientation:(tab4Image.imageOrientation)];
    
    UIImage *tab4SelectedImage = [UIImage imageNamed:@"Search"];
    UIImage *scaledTab4SelectedImage = [UIImage imageWithCGImage: [tab4SelectedImage CGImage] scale:(tab4SelectedImage.scale * 4) orientation:(tab4SelectedImage.imageOrientation)];
    (void)[tab4 initWithTitle:@"搜索" image:scaledTab4Image selectedImage:scaledTab4SelectedImage];
    
    UIImage *tab5Image = [UIImage imageNamed:@"Aavatar"];
    UIImage *scaledTab5Image = [UIImage imageWithCGImage: [tab5Image CGImage] scale:(tab5Image.scale * 4) orientation:(tab5Image.imageOrientation)];
    
    UIImage *tab5SelectedImage = [UIImage imageNamed:@"Aavatar"];
    UIImage *scaledTab5SelectedImage = [UIImage imageWithCGImage: [tab5SelectedImage CGImage] scale:(tab5SelectedImage.scale * 4) orientation:(tab5SelectedImage.imageOrientation)];
    (void)[tab5 initWithTitle:@"个人" image:scaledTab5Image selectedImage:scaledTab5SelectedImage];
    
}

@end
