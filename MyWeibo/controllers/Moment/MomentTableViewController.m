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
#import "UserLoginViewController.h"
#import "RefreshControl.h"
#import "NSString+Format.h"

@interface MomentTableViewController ()<RefreshControlDelegate> {
    NSArray *tableData;
    RefreshControl *refreshControl;
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

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [self initValues];
    [self initBasicData];
    [self setUpForTableView];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Values

- (void)initValues
{
    tableData = [[NSMutableArray alloc] init];

    self.sizeOfRefresh = 10;
    self.count = 0;
    
    miniMomentID = [NSNumber numberWithInt:0];
    
    refreshControl = [[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    refreshControl.topEnabled = YES;
    refreshControl.bottomEnabled = YES;
}

#pragma Init tableData

- (void)initBasicData
{
    [SVProgressHUD showWithStatus:@"正在加载。。"];
    [self refreshMoreData];
}

#pragma mark - Set Up For TableView

- (void)setUpForTableView
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

#pragma mark - Refresh Controll

- (void)loadTableData
{
    DDLogDebug(@"RefreshDirection:%u", refreshControl.refreshingDirection);
    
    self.count = tableData.count;
    
    DDLogDebug(@"Moments count %ld", self.count);
    
    [self.tableView reloadData];
    
    if (refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
    }
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction
{
    if (direction==RefreshDirectionTop)
    {
        [self refreshMoreData];
    }
    else {
        [self loadMoreData];
    }
}

#pragma mark - Data From Web Server

- (void)refreshMoreData
{
    if ([Support isReachabileToNet]) {
        AVQuery *query = [AVQuery queryWithClassName:@"MomentModel"];
        [query addDescendingOrder:MomentID];
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
                miniMomentID = [[objects lastObject] objectForKey:MomentID];
                DDLogDebug(@"MiniMomentID :%@", miniMomentID);
                
                [MyWeiboDefaults updateValue:tableData forKey:LatestTenMoments];
                
                [self loadTableData];
            }
        }];
        
    } else {
        [SVProgressHUD showInfoWithStatus:AlertNotReachableNetWork];
        if ([tableData count] == 0) {
            NSString *localData = [MyWeiboDefaults stringOfKey:LatestTenMoments];
            if (![localData isBlank]) {
                tableData = (NSArray *) localData;
                [SVProgressHUD showSuccessWithStatus:@"本地加载成功"];
            } else {
                [SVProgressHUD showInfoWithStatus:@"暂时没有动态"];
            }
        }
        [self loadTableData];
    }
}

- (void)loadMoreData
{
    if ([Support isReachabileToNet]) {
        DDLogDebug(@"Lastest Moment ID:%@", miniMomentID);
        AVQuery *query = [AVQuery queryWithClassName:@"MomentModel"];
        [query addDescendingOrder:MomentID];
        [query whereKey:MomentID lessThan:miniMomentID];
        query.limit = 10;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                DDLogError(@"getFirstObject Fail");
                [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
                [self loadTableData];
            } else if (objects.count > 0) {
                DDLogDebug(@"New Moments:%@", [MomentModel arrayOfObjects:objects]);
                [SVProgressHUD showSuccessWithStatus:@"加载成功"];
                tableData =
                    [tableData arrayByAddingObjectsFromArray: [MomentModel arrayOfObjects: objects]];
                miniMomentID = [[objects lastObject] objectForKey:MomentID];
                DDLogDebug(@"MiniMomentID :%@", miniMomentID);
                [self loadTableData];
            } else {
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
        [cell setAvatarAsRound];
    }

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long index = (long)indexPath.row;
    MomentDetailViewController *detailView = [[MomentDetailViewController alloc] init];
    detailView.mommentData = tableData[index];
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - TabBar Actions

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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"还没登录" message:@"马上登录" delegate:self cancelButtonTitle:CancelBtnTitle otherButtonTitles:GotoLoginBtnTitle, nil];
 
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
     if ([btnTitle isEqualToString:GotoLoginBtnTitle] ) {
        UserLoginViewController *loginViewController = [[UserLoginViewController alloc] init];         
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
@end
