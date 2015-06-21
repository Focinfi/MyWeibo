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
    NSArray *tableData;
    NSString *cancelBtnTitle;
    NSString *gotoLoginBtnTitle;
    RefreshControl *refreshControl;
    NSNumber *maxMomentID;
    NSNumber *miniMomentID;
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
    
    maxMomentID = [NSNumber numberWithInt:0];
    miniMomentID = [NSNumber numberWithInt:0];
    
    cancelBtnTitle = @"稍后再说";
    gotoLoginBtnTitle = @"马上登录";
    refreshControl = [[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
}

#pragma Init tableData

- (void) dismissProcessorAndInitTableData
{
    [SVProgressHUD dismiss];
    [self loadTableData];
    [self initAVOS];
}

- (void) initAVOS
{
//    lastestMomentID = [tableData[0] objectForKey:MomentID];
    maxMomentID = [NSNumber numberWithInt:10];
    DDLogDebug(@"Lastest Moment ID:%@", maxMomentID);
    AVQuery *query = [AVQuery queryWithClassName:@"MomentModel"];
    [query addDescendingOrder:MomentID];

    [query whereKey:MomentID greaterThan:maxMomentID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            DDLogError(@"getFirstObject Fail");
        } else {            
            DDLogDebug(@"New Moments:%@", [MomentModel arrayOfObjects:objects]);
        }
    }];
}

- (void) loadTableData
{
    [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [refreshControl finishRefreshingDirection:RefreshDirectionBottom];

    if (tableData.count == self.count) {
        [SVProgressHUD showInfoWithStatus:@"没有更多了"];
        refreshControl.bottomEnabled = NO;
    } else {
        self.count = tableData.count;
    }

    DDLogDebug(@"Moments count %ld", self.count);
    
    [self.tableView reloadData];
}


#pragma mark - Set Up For TableView

- (void) setUpForTableView
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets=NO;

    }
}

#pragma mark - Refresh Controll Delegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    if (direction==RefreshDirectionTop)
    {
        [self refreshMoreData];
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

#pragma mark - Refresh Data

- (void) initBasicData
{
    [SVProgressHUD showWithStatus:@"正在加载。。"];
    [self refreshMoreData];
}

- (void) insearItemsToTableData
{
    long to = self.count + self.sizeOfRefresh;

    NSLog(@"Comments Count in countOfItems: %d", [MomentModel countOfMoments]);
    NSArray *comments = [MomentModel arrayOfItemsFrom:self.count to:to];
    NSLog(@"Refresh Moments Count:%lu", [comments count]);
    tableData = [tableData arrayByAddingObjectsFromArray:comments];
}

#pragma mark - Data From Web Server

- (void) refreshMoreData
{
    if ([Support isReachabileToNet]) {
        AVQuery *query = [AVQuery queryWithClassName:@"MomentModel"];
        [query addDescendingOrder:MomentID];
        [query whereKey:MomentID greaterThan:maxMomentID];
        query.limit = 10;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                DDLogError(@"getFirstObject Fail");
                [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
                [self loadTableData];

            } else {
                DDLogDebug(@"New Moments:%@", [MomentModel arrayOfObjects:objects]);
                [SVProgressHUD showSuccessWithStatus:@"加载成功"];
                tableData = [MomentModel arrayOfObjects:objects];
                [self loadTableData];
            }
        }];
        
    } else {
        [SVProgressHUD showInfoWithStatus:AlertNotReachableNetWork];
        if ([tableData count] == 0) {
            [self insearItemsToTableData];
            [self loadTableData];
            [SVProgressHUD showSuccessWithStatus:@"本地加载成功"];
        }
    }
}

- (void) loadMoreData
{
    if ([Support isReachabileToNet]) {
        maxMomentID = [NSNumber numberWithInt:10];
        DDLogDebug(@"Lastest Moment ID:%@", maxMomentID);
        AVQuery *query = [AVQuery queryWithClassName:@"MomentModel"];
        [query addDescendingOrder:MomentID];
        //        [query whereKey:MtomentID greaterThan:lastestMomentID];
        query.limit = 10;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                DDLogError(@"getFirstObject Fail");
                [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
                [self insearItemsToTableData];
                [self loadTableData];
                [SVProgressHUD showSuccessWithStatus:@"本地加载成功"];
                [refreshControl finishRefreshingDirection:RefreshDirectionTop];
            } else {
                DDLogDebug(@"New Moments:%@", [MomentModel arrayOfObjects:objects]);
                [SVProgressHUD showSuccessWithStatus:@"加载成功"];
                //                [tableData addObjectsFromArray:[MomentModel arrayOfObjects:objects]];
                tableData = [MomentModel arrayOfObjects:objects];
                [self loadTableData];
            }
        }];
        
    } else {
        [SVProgressHUD showInfoWithStatus:AlertNotReachableNetWork];
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
    MomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MomentCellId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:MomentCellId owner:self options:nil] lastObject];
    }

    [cell setAvatarAsRound];
    long index = (long)indexPath.row;
        
    NSDictionary *d = (NSDictionary *) [tableData objectAtIndex:index];
    NSDictionary *userInfo = [d objectForKey:MomentUser];
    DDLogDebug(@"User Info:%@", userInfo);
    NSMutableArray *images = [d objectForKey:ImageTableName];
    cell.avatar.image = [[UIImage alloc]
                         initWithContentsOfFile:
                         [Support stringOfFilePathForImageName:[userInfo objectForKey:UserAvatar]]];
    cell.name.text = [userInfo objectForKey:UserName];
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
    long index = (long)indexPath.row;
    MomentDetailViewController *detailView = [[MomentDetailViewController alloc] init];
    detailView.mommentData = tableData[index];
    [self.navigationController pushViewController:detailView animated:YES];
}


- (IBAction)AddMommentAction:(id)sender {

    if ([Support isReachabileToNet]){
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser) {
            [MyWeiboDefaults updateValue:currentUser.username forKey:CurrentUser];
            [MyWeiboDefaults updateValue:@"YES" forKey:LoggedIn];
            DDLogDebug(@"%@:%@", CurrentUser, currentUser.username);
            DDLogDebug(@"%@:%@", LoggedIn, [MyWeiboDefaults stringOfKey:LoggedIn]);
            AddMomentViewController *addMommentViewController = [[AddMomentViewController alloc] init];
            addMommentViewController.momentTableViewController = self;
            [self.navigationController pushViewController:addMommentViewController animated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"还没登录" message:@"现在就去登录页面" delegate:self cancelButtonTitle:cancelBtnTitle otherButtonTitles:gotoLoginBtnTitle, nil];
 
            [alert show];
        }

    } else {
        [SVProgressHUD showInfoWithStatus:AlertNotReachableNetWork];
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
