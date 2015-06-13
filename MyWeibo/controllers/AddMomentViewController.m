//
//  AddMommentViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/6/12.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "AddMomentViewController.h"
#import "MomentModel.h"
#import "ImageModel.h"
#import "Support.h"
#import "DBIdentifiers.h"
#import "SVProgressHUD.h"
#import "MomentTableViewController.h"

@interface AddMomentViewController (){
    int imageWidth;
    int imageOriginX;
    int imageOriginY;
    int imagesLine;
    int imagesCount;
    int imagePadding;
    MomentModel *newMoment;
}

@end

@implementation AddMomentViewController

- (void)viewDidLoad {
    [self initValues];
    [self setTitleAndBarButton];
    [self setTextView];
    [self setAddImageButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) initValues
{
    imageWidth = 90;
    imageOriginX = 40;
    imageOriginY = 340;
    imagesLine = 0;
    imagesCount = 0;
    imagePadding = 10;
    newMoment = [[MomentModel alloc] init];
    newMoment.momentID = [DBIdentifiers stringOfIdentifier:@"moment_id"];
    newMoment.images = [NSMutableArray array];
}

- (void) setTitleAndBarButton
{
    self.title = @"添加Moment";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveMoment)];
    rightButton.title = @"完成";
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void) setTextView
{
    self.momentContentTextView.layer.masksToBounds = YES;
    self.momentContentTextView.layer.cornerRadius = 8;
    self.momentContentTextView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.9];
}

- (void) setAddImageButton
{
    UIImage *addImage = [UIImage imageNamed:@"AddImage"];
    UIImageView *addImageView = [[UIImageView alloc] initWithImage:addImage];
    int imageX = imageOriginX + (imagesCount % 3) * (imageWidth + imagePadding);
    int imageY = imageOriginY + (imagesCount / 3) * (imageWidth + imagePadding);
    addImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageWidth);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    addImageView.userInteractionEnabled = YES;
    [addImageView addGestureRecognizer:tap];
    [self.view addSubview:addImageView];
}

- (void) addImagePreview:(UIImage *) imageView
{
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:imageView];
    int imageX = imageOriginX + (imagesCount % 3) * (imageWidth + imagePadding);
    int imageY = imageOriginY + (imagesCount / 3) * (imageWidth + imagePadding);
    newImageView.frame = CGRectMake(imageX, imageY, imageWidth, imageWidth);

    imagesCount++;
    [self.view addSubview:newImageView];
}

#pragma mark Set Actions

- (void) saveMoment
{
    NSString *momentContentText = self.momentContentTextView.text;
    if (momentContentText.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"Moment不能为空哦"];
    } else if ([newMoment.images count] == 0){
        [SVProgressHUD showErrorWithStatus:@"添加个图片吧"];
    } else {
        newMoment.userID = @"1";
        newMoment.content = momentContentText;
        NSLog(@"WillSave moment_id:%@, images:%lu", newMoment.momentID, [newMoment.images count]);
        
        [newMoment save];
        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) chooseImage
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
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

#pragma mark actionsheet delegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
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
    NSString *imageName = [NSString stringWithFormat:@"moment_image_%@", [DBIdentifiers stringOfIdentifier:@"moment_image_id"]];
    [Support saveImage:image withName:imageName];
    
    NSLog(@"Moment ID:%@", newMoment.momentID);
    
    ImageModel *newImageModel = [[ImageModel alloc] init];
    newImageModel.momentID = newMoment.momentID;
    newImageModel.name = imageName;
    [newMoment.images addObject:newImageModel];
    NSLog(@"WillSave moment_id:%@, images:%lu", newMoment.momentID, [newMoment.images count]);

    [self addImagePreview:image];
    if (imagesCount < 6) {
        [self setAddImageButton];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
@end
