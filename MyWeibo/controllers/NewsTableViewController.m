//
//  NewsTableViewController.m
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewTableViewCell.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MyWeiApp.h"
#import "SVProgressHUD.h"
#import "DataWorker.h"
#import "CommentModel.h"
#import "ImageModel.h"

@interface NewsTableViewController () {
    NSMutableArray *tableData;
    NSString *_avatar;
    NSString *_name;
    NSString *_description;
    NSString *_content;
    NSString *_weiboImage;
}

@end

@implementation NewsTableViewController
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
    [self initDB];
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
    _weiboImage = @"weibo_image";

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

- (void) initDB
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

    NSLog(@"Comments Count in countOfItems: %d", [CommentModel countOfComments]);
    NSArray *comments = [CommentModel arrayOfItemsFrom:self.count to:to];
//    NSLog(@"Keys : %@", [[comments objectAtIndex:0] allKeys]);
//    NSLog(@"Images1 : %@", [[comments objectAtIndex:0] objectForKey:@"images"]);
//    
//    NSLog(@"Images Count in inserItems: %d", [ImageModel countOfImages]);
//    NSLog(@"Comments Count in insertItems: %lu", (unsigned long)[comments count]);

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
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil] lastObject];
        [cell setAvatarAsRound];
    }
    
    long r = (long)indexPath.row;
    long index = self.count - 1 - r;
        
    NSDictionary *d = (NSDictionary *) [tableData objectAtIndex:index];
    NSDictionary *userInfo = [d objectForKey:@"user"];
    NSArray *images = [d objectForKey:@"images"];

    cell.avatar.image = [UIImage imageNamed:[userInfo objectForKey:_avatar]];
    cell.name.text = [[userInfo objectForKey:_name] stringByAppendingFormat:@"_%ld", index];
    cell.description.text = [userInfo objectForKey:_description];
    cell.weibo.text = [d objectForKey:@"content"];
    
    NSString *image_name = @"weibo1";
    NSLog(@"Images Count in Cell: %lu", [[d objectForKey:@"images"] count]);
    if ([[d objectForKey:@"images"] count] > 0) {
         image_name = [[images objectAtIndex:0] objectForKey:@"name"];
    }
    
    cell.weiboImage.image = [UIImage imageNamed:image_name];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = (NewTableViewCell *)[tableView cellForRowAtIndexPath: indexPath];
//    cell.description.text = [cell.description.text stringByAppendingString:@"X"];
}

@end
