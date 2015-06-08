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

@implementation DBManager

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
    NSLog(@"Columns: %@", keys);

    NSString *mapString;
    NSMutableArray *pairs = [NSMutableArray array];
    
    for (int i = 0; i < keys.count; i++) {
        NSString * type = [colums objectForKey:keys[i]];
        NSLog(@"Value: %@", type);
        NSString *assemble = [keys[i] stringSwapWithBoundary:@"'"];
        assemble = [assemble stringByAppendingFormat:@" %@", type];
        NSLog(@"Ass: %@", assemble);
        [pairs addObject:assemble];
    }
    
    NSLog(@"Pairs count: %lu", (unsigned long)pairs.count);
    mapString = [pairs stringByJoinEntierWithBoundary:@","]; 
    NSLog(@"Pairs: %@", pairs);
    return mapString;
}

#pragma mark - Connect DB

- (void) connectDBName:(NSString *)name
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath:name]];

    NSLog(@"connect DB");
    self.db = db;
}

#pragma mark - Create Table

- (BOOL) createTableName:(NSString *)name columns:(NSDictionary *)colums
{
    if ([self.db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT, %@)",name,[self makeSqlString: colums]];
        
        BOOL res = [self.db executeUpdate:sqlCreateTable];
        NSLog(@"create table");
        if (!res) {
            NSLog(@"error when creating db table");
            [self.db close];
            return NO;
        } else {
            NSLog(@"success to creating db table");
            [self.db close];
        }
    }
    return YES;
}

#pragma mark - Query

- (NSUInteger) queryCountOfTableName:(NSString *)name
{
    if ([self.db open]) {
        NSUInteger newsTotalCount = [self.db intForQuery:[NSString stringWithFormat:@"select count(*) from %@", name]];
        NSLog(@"Count of news: %lu", (unsigned long)newsTotalCount);
        return newsTotalCount;
    }
    
    return 0;
}


- (NSArray *) arrayBySelect:(NSArray *) columns fromTable:(NSString *) name where:(NSDictionary *) conditions from:(long) from to:(long) to;
{
    NSLog(@"%@", columns);
    NSMutableArray *data = [NSMutableArray array];
    
    if ([self.db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ ", name];
        if (conditions) {
            sql = [sql stringByAppendingString:[NSString stringWithFormat:@"WHERE %@", [conditions stringByJoinEntierWithBoundary:@" AND "]]];
//            sql = [sql stringByAppendingString:@"WHERE name = '仓井优'"];
        }
        FMResultSet * rs = [self.db executeQuery:sql];
        
        for (int first = 0; [rs next] && first < to; first++) {
            NSLog(@"Count in seart: %d", first);
            if (first >= from && first < to) {
                NSMutableDictionary *item = [NSMutableDictionary dictionary];
                for (int i = 0; i < columns.count; i++) {
                    NSString *value = [rs stringForColumn:columns[i]];
                    NSLog(@"%@: %@", columns[i], [rs stringForColumn:@"avatar"]);
                    if (value != nil) {
                        NSLog(@"Count: %d", i);
                        [item setValue:value forKey:columns[i]];
                    }
                }
                NSLog(@"RS ID: %@", [rs objectForColumnName:@"id"]);
                [data addObject:item];
            }
        }
        
        [self.db close];
    }

    return data;
}

#pragma mark - Insert

- (BOOL) insearItemsTableName:(NSString *)name columns:(NSDictionary *)columns
{
    if ([self.db open]) {
        
        NSArray *keys = [columns allKeys];
        NSArray *values = [columns allValues];
        NSString *insertSql = [NSString stringWithFormat:
                               @"INSERT INTO %@ (%@) VALUES (%@)",
                               name, [keys stringByJoinEntierWithBoundary:@","], [values stringByJoinEntierWithBoundary:@","]];
        
        BOOL res = [self.db executeUpdate:insertSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
            [self.db close];
            return NO;
        } else {
            NSLog(@"success to insert db table");
            [self.db close];
        }
    }
    return YES;
}


@end

