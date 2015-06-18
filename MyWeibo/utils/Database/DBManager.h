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
- (NSArray *) arrayOfAllBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions;
- (NSArray *) arrayOfAllBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions orderBy:(NSDictionary *) order;
- (NSArray *) arrayBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions orderBy:(NSDictionary *) order from:(long) from to:(long) to;
- (int) countOfItemsNumberInTable:(NSString *)name;
- (NSDictionary *) dictionaryBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions;
- (BOOL) excuteSQLs:(NSArray *) sqls;

@end
