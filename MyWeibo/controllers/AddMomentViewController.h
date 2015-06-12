//
//  AddMommentViewController.h
//  MyWeibo
//
//  Created by focinfi on 15/6/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMomentViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *momentContentTextView;


@end
