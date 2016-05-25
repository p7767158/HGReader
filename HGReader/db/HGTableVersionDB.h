//
//  HGTableVersionDB.h
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGBaseDB.h"

static NSString * const kVersionDB = @"dbversion.db";
static NSString * const kVersionTbl = @"version";

@interface HGTableVersionDB : HGBaseDB

+ (HGTableVersionDB *)sharedHGTableVersionDB;
- (void)getTblVersionForDB:(NSString *)db finishBlock:(void(^)(NSDictionary *))finishBlock;
- (void)getVersionForTbl:(NSString *)tbl inDB:(NSString *)db finishBlock:(void(^)(int version))finishBlock;
- (void)updateVersion:(int)version forTbl:(NSString *)tbl inDB:(NSString *)db;
- (void)initStore:(NSString *)baseUrl;

@end
