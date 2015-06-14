//
//  DBManager.m
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "NSDictionary+Assemble.h"
#import "NSArray+Assemble.h"
#import "NSString+Format.h"
#import "CocoaLumberjack.h"

@implementation DBManager{
    FMDatabaseQueue* dBQueue;
}

#pragma mark - Supporting Utils

- (NSString *) dbPath:(NSString *)name
{
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_focinfi.sql", name]];
    
    return databaseFilePath;
}

- (NSString *) makeSqlString:(NSDictionary *) colums
{
    NSArray *keys = [colums allKeys];
    DDLogVerbose(@"Columns: %@", keys);

    NSString *mapString;
    NSMutableArray *pairs = [NSMutableArray array];
    

    for (NSString *key in keys) {
        NSString * type = [colums objectForKey:key];
        DDLogVerbose(@"Value: %@", type);
        NSString *assemble = [key stringSwapWithBoundary:@"'"];
        assemble = [assemble stringByAppendingFormat:@" %@", type];
        DDLogVerbose(@"Ass: %@", assemble);
        [pairs addObject:assemble];
    }
    
    DDLogVerbose(@"Pairs count: %lu", (unsigned long)pairs.count);
    mapString = [pairs stringByJoinSimpelyWithBoundary:@","];
    DDLogVerbose(@"Pairs: %@", pairs);
    return mapString;
}

#pragma mark - Init

- (id) init
{
    self = [super init];
    if (self) {
        dBQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath:@"myweibo_db16"]];
    }
    return self;
}

#pragma mark - Connect DB

- (void) connectDB
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath:@"myweibo_db10"]];
    dBQueue = queue;
}

#pragma mark - Create Table

- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)colums
{

    NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@)",name,[self makeSqlString: colums]];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:sqlCreateTable];
        DDLogVerbose(@"create table");
    }];
    return YES;
}

#pragma mark - Query

- (int) countOfItemsNumberInTable:(NSString *)name
{
    __block int newsTotalCount = 0;
    
    [dBQueue inDatabase:^(FMDatabase *db){
        newsTotalCount = [db intForQuery:[NSString stringWithFormat:@"select count(*) from %@", name]];
    }];
    
    return newsTotalCount;
}

- (NSDictionary *) dictionaryBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@ ", name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"WHERE %@", [conditions stringByJoinEntierWithBoundary:@" AND "]]];
    }
    
    __block NSMutableDictionary *item = [NSMutableDictionary dictionary];
;
    [dBQueue inDatabase:^(FMDatabase *db){
        FMResultSet * rs = [db executeQuery:sql];
        [rs next];
        for (int i = 0; i < columns.count; i++) {
            NSString *value = [rs stringForColumn:columns[i]];
            if (value != nil) {
                DDLogVerbose(@"Count: %d", i);
                [item setValue:value forKey:columns[i]];
            }
        }
        [rs close];
    }];

    return item;
}

- (NSArray *) arrayOfAllBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@ ", name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"WHERE %@", [conditions stringByJoinEntierWithBoundary:@" AND "]]];
    }
    __block NSMutableArray *data = [NSMutableArray array];

    [dBQueue inDatabase:^(FMDatabase *db){
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *item = [NSMutableDictionary dictionary];
            for (int i = 0; i < columns.count; i++) {
                NSString *value = [rs stringForColumn:columns[i]];
                if (value != nil) {
                    DDLogVerbose(@"Count: %d", i);
                    [item setValue:value forKey:columns[i]];
                }
            }
            [data addObject:item];
        }
        [rs close];
    }];

    return data;
}

- (NSArray *) arrayBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions from:(long) from to:(long) to
{
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@ ", name];
    if (conditions) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"WHERE %@", [conditions stringByJoinEntierWithBoundary:@" AND "]]];
    }

    __block NSMutableArray *data = [NSMutableArray array];

    [dBQueue inDatabase:^(FMDatabase *db){
        FMResultSet * rs = [db executeQuery:sql];
        for (int first = 0; [rs next] && first < to; first++) {
            DDLogVerbose(@"Count in seart: %d", first);
            if (first >= from && first < to) {
                NSMutableDictionary *item = [NSMutableDictionary dictionary];
                for (int i = 0; i < columns.count; i++) {
                    NSString *value = [rs stringForColumn:columns[i]];
                    if (value != nil) {
                        DDLogVerbose(@"Count: %d", i);
                        [item setValue:value forKey:columns[i]];
                    }
                }
                [data addObject:item];
            }
        }
        [rs close];
    }];
    

    return data;
}

#pragma mark - Insert

- (BOOL) insearItemsTableName:(NSString *)name columns:(NSDictionary *)columns
{
    NSArray *keys = [columns allKeys];
    NSArray *values = [columns allValues];
    NSString *insertSql = [NSString stringWithFormat:
                           @"INSERT INTO %@ (%@) VALUES (%@)",
                           name, [keys stringByJoinEntierWithBoundary:@","], [values stringByJoinEntierWithBoundary:@","]];
    [dBQueue inDatabase:^(FMDatabase *db){
        [db executeUpdate:insertSql];
    }];

    return YES;
}


#pragma mark - Execute a bundle of sqls

- (BOOL) excuteSQLs:(NSArray *) sqls
{
    [dBQueue inDatabase:^(FMDatabase *db){
        for (NSString *sql in sqls) {
            [db executeUpdate:sql];
        }
    }];
    return YES;
}


@end

