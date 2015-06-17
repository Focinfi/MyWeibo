//
//  AddMommentViewController.h
//  MyWeibo
//
//  Created by focinfi on 15/6/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentTableViewController.h"

@interface AddMomentViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *momentContentTextView;
@property (nonatomic) MomentTableViewController *momentTableViewController;
@end
