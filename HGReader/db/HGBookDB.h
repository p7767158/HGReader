//
//  HGBookDB.h
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGBaseDB.h"

static NSString * const kBookDb = @"book.db";
static NSString * const kBookTbl = @"book";

@class HGLocalBook, HGBook;
@interface HGBookDB : HGBaseDB

+ (HGBookDB *)sharedHGBookDB;
- (void)initStore:(NSString *)baseUrl;
- (void)saveBook:(HGBook *)book;
- (void)updateBookWithBid:(long long)bid withDictionary:(NSDictionary *)dict finishBlock:(void (^)())finishBlock;
- (void)deleteBookWithBid:(long long)bid finishBlock:(void (^)())finishBlock;
- (void)getBooks:(void (^)(NSArray *))finishBlock;
- (void)getBookWithBid:(long long)bid finishBlock:(void (^)(NSDictionary *))finishBlock;

@end
