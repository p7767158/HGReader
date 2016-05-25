//
//  HGBaseDB.m
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGBaseDB.h"

@interface HGBaseDB()

@property (nonatomic, strong) FMDatabase *readDb;
@property (nonatomic, strong) FMDatabase *writeDb;
@property (nonatomic, strong) FMDatabaseQueue *readQueue;
@property (nonatomic, strong) FMDatabaseQueue *writeQueue;
@property (nonatomic, copy) NSString *path;

@end

@implementation HGBaseDB

- (void)setDB:(NSString *)path
{
    _path = path;
    _readDb = [[FMDatabase alloc] initWithPath:_path];
    _writeDb = [[FMDatabase alloc] initWithPath:_path];
    _readQueue = [[FMDatabaseQueue alloc] initWithPath:_path];
    _writeQueue = [[FMDatabaseQueue alloc] initWithPath:_path];
}

- (void)doRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block
{
    if (!_readQueue) {
        return block(nil);
    }
    [_readQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *res = [db executeQuery:sql withParameterDictionary:dictParams];
        NSMutableArray *ret = @[].mutableCopy;
        while ([res next]) {
            [ret addObject:[res resultDictionary]];
        }
        block(ret);
    }];
}

- (void)doWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block
{
    __block long long lastId;
    [_writeQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:sql withParameterDictionary:dictParams]) {
            lastId = [db lastInsertRowId];
        } else {
            lastId = -db.lastErrorCode;
        }
        block(lastId);
    }];
}

- (void)doSyncWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block
{
    long long lastId;
    FMDatabase *db = [[FMDatabase alloc] initWithPath:_path];
    [db open];
    if ([db executeUpdate:sql withParameterDictionary:dictParams]) {
        lastId = [db lastInsertRowId];
    } else {
        lastId = -db.lastErrorCode;
    }
    [db close];
    block(lastId);
}

- (void)doSyncRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block
{
    FMDatabase *db = [[FMDatabase alloc] initWithPath:_path];
    [db open];
    FMResultSet *res = [db executeQuery:sql withParameterDictionary:dictParams];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    while ([res next]) {
        [ret addObject:[res resultDictionary]];
    }
    [db close];
    block(ret);
}

@end
