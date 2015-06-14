//
//  DBManager.h
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DBManager : NSObject

- (void) connectDB;
- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)colums;
- (BOOL) insearItemsTableName:(NSString *)name columns:(NSDictionary *)columns;
- (NSArray *) arrayOfAllBySelect:(NSArray *) colums fromTable:(NSString *) name where:(NSDictionary *) conditions;
- (NSArray *) arrayBySelect:(NSArray *) colums fromTable:(NSString *) name where:(NSDictionary *) conditions from:(long) from to:(long) to;
- (int) countOfItemsNumberInTable:(NSString *)name;
- (NSDictionary *) dictionaryBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions;
- (BOOL) excuteSQLs:(NSArray *) sqls;

//@property (nonatomic) FMDatabaseQueue *dBQueue;
@end
