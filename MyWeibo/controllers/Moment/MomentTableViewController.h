//
//  NewsTableViewController.h
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface MomentTableViewController : UITableViewController
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger sizeOfRefresh;
@property (nonatomic) NSArray *columns;
@property (nonatomic) NSDictionary *clickedCellData;
- (IBAction)AddMommentAction:(id)sender;
@end
