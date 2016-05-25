//
//  HGBaseDB.h
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface HGBaseDB : NSObject

typedef void (^ReadFinishBlock)(NSArray *res);
typedef void (^WriteFinishBlock)(long long lastId);

- (void)setDB:(NSString *)path;
//- (void)run;
- (void)doRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block;
- (void)doSyncRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block;
- (void)doWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block;
- (void)doSyncWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block;

@end
