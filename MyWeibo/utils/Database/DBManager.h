//
//  DBManager.h
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBManager : NSObject

- (NSString *) dbPath:(NSString *)name;
- (void) connectDBName: (NSString *)name;
- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)colums;
- (BOOL) insearItemsTableName:(NSString *)name columns:(NSDictionary *)columns;
- (NSArray *) arrayBySelect:(NSArray *) colums fromTable:(NSString *) name where:(NSDictionary *) conditions from:(long) from to:(long) to;
- (int) countOfItemsNumberInTable:(NSString *)name;
- (NSDictionary *) dictionaryBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions;

@property (nonatomic) FMDatabase *db;
@end
