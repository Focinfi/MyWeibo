//
//  NewsTableViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MomentTableViewController.h"
#import "MomentDetailViewController.h"
#import "NewTableViewCell.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MyWeiApp.h"
#import "SVProgressHUD.h"
#import "DataWorker.h"
#import "MomentModel.h"
#import "ImageModel.h"
#import "AddMomentViewController.h"

@interface MomentTableViewController () {
    NSMutableArray *tableData;
    NSString *_avatar;
    NSString *_name;
    NSString *_description;
    NSString *_content;
}

@end

@implementation MomentTableViewController
@synthesize count;
@synthesize sizeOfRefresh;
@synthesize dbManager;

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
    [self addRefreshViewControl];
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

    self.dbManager = [MyWeiApp sharedManager].databaseManager;
    self.sizeOfRefresh = 10;
    self.count = 0;
    
    _avatar = @"avatar";
    _name = @"name";
    _description = @"description";
    _content = @"weibo";
}

- (void) initTableData
{
    [self insearItemsToTableData];
    self.count = tableData.count;
    [self.tableView reloadData];
}


#pragma mark - Set Up For Table View

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

    [tableData addObjectsFromArray:comments];
    
}

#pragma Init tableData

- (void) dismissProcessorAndInitTableData
{
    [SVProgressHUD dismiss];
    [self initTableData];
}

#pragma mark - Refresh Controller

-(void)addRefreshViewControl
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}


-(void)RefreshViewControlEventValueChanged
{
    
    if (self.refreshControl.refreshing) {
        NSLog(@"refreshing");
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
        
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0.5];
        
    }
}

- (void) handleData
{
    NSLog(@"refreshed");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self insearItemsToTableData];
        if (tableData.count > self.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新成功"];
                self.count = tableData.count;
                [self.tableView reloadData];
                [self performSelector:@selector(endRefreshingAinamation) withObject:nil afterDelay:0.5];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"没有更新的新鲜事了"];
                [self performSelector:@selector(endRefreshingAinamation) withObject:nil afterDelay:0.5];
            });
        }
    });
}

- (void) endRefreshingAinamation
{
    [self.refreshControl endRefreshing];
    [self performSelector:@selector(changeRefreshingTitle) withObject:nil afterDelay:1];
}

- (void) changeRefreshingTitle
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}

#pragma mark - Table view settings

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";    
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil] lastObject];
//    }
    cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil] lastObject];
    [cell setAvatarAsRound];
    long r = (long)indexPath.row;
    long index = self.count - 1 - r;
        
    NSDictionary *d = (NSDictionary *) [tableData objectAtIndex:index];
    NSDictionary *userInfo = [d objectForKey:@"user"];
    NSArray *images = [d objectForKey:@"images"];

    cell.avatar.image = [UIImage imageNamed:[userInfo objectForKey:_avatar]];
    cell.name.text = [[userInfo objectForKey:_name] stringByAppendingFormat:@"_%ld", index];
    cell.description.text = [userInfo objectForKey:_description];
    cell.weibo.text = [d objectForKey:@"content"];
    NSLog(@"Detail Data T%ld%@", index, images);

    NSLog(@"Images Count in Cell: %lu", [[d objectForKey:@"images"] count]);
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
    NSLog(@"Detail Data T%@", [tableData[index] objectForKey:@"images"]);

    detailView.mommentData = tableData[index];
    [self.navigationController pushViewController:detailView animated:YES];
}


- (IBAction)AddMommentAction:(id)sender {
    AddMomentViewController *addMommentViewController = [[AddMomentViewController alloc] init];
    [self.navigationController pushViewController:addMommentViewController animated:YES];
}
@end
