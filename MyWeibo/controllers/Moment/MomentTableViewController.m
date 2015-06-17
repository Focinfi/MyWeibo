//
//  NewsTableViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MomentTableViewController.h"
#import "MomentDetailViewController.h"
#import "MomentTableViewCell.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MyWeiApp.h"
#import "SVProgressHUD.h"
#import "DataWorker.h"
#import "MomentModel.h"
#import "ImageModel.h"
#import "AddMomentViewController.h"
#import "Random.h"
#import "AVOSCloud.h"
#import "Support.h"
#import "MyWeiboDefaults.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "LoginViewController.h"
#import "RefreshControl.h"

@interface MomentTableViewController ()<RefreshControlDelegate> {
    NSMutableArray *tableData;
    NSString *cancelBtnTitle;
    NSString *gotoLoginBtnTitle;
    RefreshControl *refreshControl;
}

@end

@implementation MomentTableViewController
@synthesize count;
@synthesize sizeOfRefresh;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [self initValues];
    [self initBasicData];
//    [self addRefreshViewControl];
    [self setUpForTableView];
    [super viewDidLoad];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Values

- (void) initValues
{
    tableData = [[NSMutableArray alloc] init];

    self.sizeOfRefresh = 10;
    self.count = 0;
    
    cancelBtnTitle = @"稍后再说";
    gotoLoginBtnTitle = @"马上登录";
    refreshControl = [[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    refreshControl.topEnabled = NO;
    refreshControl.bottomEnabled = YES;
//    refreshControl.enableInsetTop = 65;
    refreshControl.enableInsetBottom = 110;
    
    [self initAVOS];
}

- (void) initAVOS
{
}

- (void) loadTableData
{
    [self insearItemsToTableData];
    self.count = tableData.count;
    
    if (refreshControl.refreshingDirection == RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection == RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    
    [self.tableView reloadData];
//    self.tableView.contentOffset = ;
}


#pragma mark - Set Up For TableView

- (void) setUpForTableView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - News Database operation

- (void) initBasicData
{
    [SVProgressHUD showWithStatus:@"Loading"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DataWorker insertBasicDataWihtNumber:20];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(dismissProcessorAndInitTableData) withObject:nil afterDelay:1];
        });
    });
}

- (void) insearItemsToTableData
{
    long to = self.count + self.sizeOfRefresh;

    NSLog(@"Comments Count in countOfItems: %d", [MomentModel countOfMoments]);
    NSArray *comments = [MomentModel arrayOfItemsFrom:self.count to:to];
    NSLog(@"Refresh Moments Count:%lu", [comments count]);
    [tableData addObjectsFromArray:comments];
}

#pragma Init tableData

- (void) dismissProcessorAndInitTableData
{
    [SVProgressHUD dismiss];
    [self loadTableData];
}

#pragma mark - Refresh Controll Delegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    if (direction==RefreshDirectionTop)
    {
       
        
    }
    else if (direction==RefreshDirectionBottom)
    {
        __weak typeof(self)weakSelf=self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf=weakSelf;
            [strongSelf loadTableData];
            
        });
    }
    
}

#pragma mark - TableView Data Source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MomentCell";    
    MomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MomentCell" owner:self options:nil] lastObject];
    }

    [cell setAvatarAsRound];
    long r = (long)indexPath.row;
    long index = self.count - 1 - r;
        
    NSDictionary *d = (NSDictionary *) [tableData objectAtIndex:index];
    NSDictionary *userInfo = [d objectForKey:@"user"];
    NSMutableArray *images = [d objectForKey:ImageTableName];
    cell.avatar.image = [UIImage imageNamed:[userInfo objectForKey:UserAvatar]];
    cell.name.text = [[userInfo objectForKey:UserName] stringByAppendingFormat:@"_%ld", index];
    cell.description.text = [userInfo objectForKey:UserDescription];
    cell.weibo.text = [d objectForKey:MomentContent];

    [cell setImages:images];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long r = (long)indexPath.row;
    long index = self.count - 1 - r;
    MomentDetailViewController *detailView = [[MomentDetailViewController alloc] init];
    detailView.mommentData = tableData[index];
    [self.navigationController pushViewController:detailView animated:YES];
}


- (IBAction)AddMommentAction:(id)sender {

    if ([Support isReachabileToNet]){
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser) {
            [MyWeiboDefaults updateValue:currentUser.username forKey:@"current_user"];
            [MyWeiboDefaults updateValue:@"YES" forKey:@"logged_in"];
            DDLogDebug(@"current_user:%@", currentUser.username);
            DDLogDebug(@"logged_in:%@", [MyWeiboDefaults stringOfKey:@"logged_in"]);
            AddMomentViewController *addMommentViewController = [[AddMomentViewController alloc] init];
            addMommentViewController.momentTableViewController = self;
            [self.navigationController pushViewController:addMommentViewController animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"还没登录" message:@"现在就去登录页面" delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:gotoLoginBtnTitle, nil];
 
            [alert show];
        }

    } else {
        [SVProgressHUD showInfoWithStatus:@"网络没有链接哦"];
    }
}

#pragma mark - Alert Actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
     if ([btnTitle isEqualToString:gotoLoginBtnTitle] ) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];         
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
@end
