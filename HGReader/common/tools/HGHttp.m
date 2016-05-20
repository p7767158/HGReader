//
//  HGHttp.m
//  HGReader
//
//  Created by zhh on 16/3/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGHttp.h"
#import <AFNetworking/AFNetworking.h>

static double const kTimeout = 10.0;

@interface HGHttp ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HGHttp

+ (instancetype)sharedHttp
{
    static dispatch_once_t onceToken;
    static HGHttp *hgHttp = nil;
    dispatch_once(&onceToken, ^{
        hgHttp = [[HGHttp alloc] init];
    });
    return hgHttp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        _manager = [AFHTTPSessionManager manager];
        [_manager.requestSerializer setTimeoutInterval:kTimeout];
    }
    return self;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self.manager GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

@end
