//
//  HGBookDB.m
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGBookDB.h"
#import "HGGlobal.h"
#import "HGTableVersionDB.h"
#import "HGBook.h"
#import "HGLocalBook.h"
#import <Mantle/Mantle.h>
#import "NSDictionary+HGCamelCaseKey.h"

static int const kTblVersionBook = 1;

@implementation HGBookDB

SYNTHESIZE_SINGLETON_FOR_CLASS(HGBookDB);

- (void)initStore:(NSString *)baseUrl
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseUrl, kBookDb];
    [self setDB:path];
    [[HGTableVersionDB sharedHGTableVersionDB] getTblVersionForDB:kBookDb finishBlock:^(NSDictionary *versions) {
        FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
        if ([db open]) {
            if (!versions || !versions[kBookTbl] || (kTblVersionBook > [versions[kBookTbl] integerValue])) {
                [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", kBookTbl]];
                [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (bid integer primary key, name varchar, author varchar, file_path varchar, current_page integer, current_chapter integer, open_time mediumint, cover_url varchar, current_desc varchar)", kBookTbl]];
                [[HGTableVersionDB sharedHGTableVersionDB] updateVersion:kTblVersionBook forTbl:kBookTbl inDB:kBookDb];
            }
            [db close];
        }
    }];
}

- (void)saveBook:(HGBook *)book
{
    if (book.bid > 0) {
        [self doWrite:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (bid, name, author, file_path, current_page, current_chapter, open_time, cover_url, current_desc) VALUES (:bid, :name, :author, :file_path, :current_page, :current_chapter, :open_time, :cover_url, :current_desc)", kBookTbl] withParams:@{@"bid":@(book.bid), @"name":book.name, @"author":book.author, @"file_path":[book filePath], @"current_page":@0, @"current_chapter":@0, @"open_time":@([HGGlobal now]), @"cover_url":book.coverUrl, @"current_desc":book.summary} finishBlock:^(long long lastId) {
            
        }];
    }
}

- (void)getBookWithBid:(long long)bid finishBlock:(void (^)(NSDictionary *))finishBlock
{
    NSString *sql = [NSString stringWithFormat:@"SELECT bid, name, author, file_path, current_page, current_chapter, open_time, cover_url, current_desc FROM %@ WHERE bid IN (%@)", kBookTbl, @(bid)];
    void (^block)(NSArray *) = ^(NSArray *res) {
        NSMutableDictionary *books = @{}.mutableCopy;
        if (res.count > 0) {
            HGLocalBook *book = [MTLJSONAdapter modelOfClass:HGLocalBook.class fromJSONDictionary:[res[0] camelCase] error:nil];
            books[@(book.bid)] = book;
            finishBlock(books);
        }
    };
    [self doSyncRead:sql withParams:nil finishBlock:block];
}

- (void)updateBookWithBid:(long long)bid withDictionary:(NSDictionary *)dict finishBlock:(void (^)())finishBlock
{
    
}

- (void)deleteBookWithBid:(long long)bid finishBlock:(void (^)())finishBlock
{
    
}

- (void)getBooks:(void (^)(NSArray *))finishBlock
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY open_time DESC", kBookTbl];
    void (^block)(NSArray *) = ^(NSArray *res) {
        NSMutableArray *books = @[].mutableCopy;
        [res enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull ret, NSUInteger idx, BOOL * _Nonnull stop) {
            HGLocalBook *book = [MTLJSONAdapter modelOfClass:HGLocalBook.class fromJSONDictionary:[ret camelCase] error:nil];
            [books addObject:book];
        }];
        finishBlock(books);
    };
    [self doSyncRead:sql withParams:nil finishBlock:block];
}

@end
