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

+ (instancetype)sharedTxtHttp
{
    static dispatch_once_t onceToken;
    static HGHttp *hgHttp = nil;
    dispatch_once(&onceToken, ^{
        hgHttp = [[HGHttp alloc] initWithTxt];
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

- (instancetype)initWithTxt
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setTimeoutInterval:kTimeout];
        [_manager.requestSerializer setValue:@"application/zip;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/zip", @"charset=UTF-8", nil];
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

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [self.manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

- (nullable NSURLSessionTask *)download:(nullable NSString *)URLString destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination success:(nullable void (^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath))success failure:(nullable void (^)(NSError * _Nullable error))failure
{
    return [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        } else {
            success(response, filePath);
        }
    }];
}
@end
