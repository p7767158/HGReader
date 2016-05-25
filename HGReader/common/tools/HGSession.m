//
//  HGSession.m
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGSession.h"
#import "HGBookDB.h"
#import "HGTableVersionDB.h"
#import "HGGlobal.h"

@interface HGSession ()

@property (nonatomic, copy) NSString *bookPath;
@property (nonatomic, copy) NSString *commonPath;

@end

@implementation HGSession

SYNTHESIZE_SINGLETON_FOR_CLASS(HGSession);

- (void)_initStore
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _commonPath = paths[0];
    NSString *path = [_commonPath stringByAppendingString:[NSString stringWithFormat:@"/%d/%d", 0, 013310]];
    _bookPath = path;
    if (![fileMgr fileExistsAtPath:_bookPath]) {
        NSError *e;
        if (![fileMgr createDirectoryAtPath:_bookPath withIntermediateDirectories:YES attributes:nil error:&e]) {
            //[HHMessageHelper showAlert:@"磁盘空间不足，应用使用中可能会遇到问题" title:@"警告"];
            NSLog(@"磁盘空间不足，应用使用中可能会遇到问题");
        }
    }
    //初始化数据库
    [self _initDB];
}

- (void)_initDB
{
    [[HGTableVersionDB sharedHGTableVersionDB] initStore:_bookPath];
    [[HGBookDB sharedHGBookDB] initStore:_bookPath];
}

- (NSDictionary *)userDefaultsWithBid:(long long)bid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"b%lld", bid]];
}

- (id)userDefaultForKey:(NSString *)key withBid:(long long)bid
{
    id value = [self userDefaultsWithBid:bid][key];
    if (value) {
        return value;
    } else {
        return [NSNull null];
    }
}

- (void)setUserDefault:(id)value forKey:(NSString *)key withBid:(long long)bid
{
    NSMutableDictionary *defaults = [[self userDefaultsWithBid:bid] mutableCopy];
    if (!defaults) {
        defaults = [[NSMutableDictionary alloc] init];
    }
    if (nil != value) {
        defaults[key] = value;
        [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:[NSString stringWithFormat:@"b%lld", bid]];
    } else {
        [defaults removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:[NSString stringWithFormat:@"b%lld", bid]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
