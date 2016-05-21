//
//  HGHttp.h
//  HGReader
//
//  Created by zhh on 16/3/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kHttpSubfix = @"&deviceid=707EB55C-A184-4EC7-AB70-AE0D0EB7AA22&ver=2.4.0&build=2.4.0&lan=zh&ua=ios&platform=ios&chan=1&appid=389983208&qd=1001";
static NSString * const kRecommendApi = @"http://qishu.easebook.cn/api/v2/book/recommend?page=%lld&page.size=20&uid=%@";
static NSString * const kTryReadApi = @"http://qishu.easebook.cn/api/v1/book/preview/%lld?uid=%@";

@interface HGHttp : NSObject

+ (instancetype)sharedHttp;
+ (instancetype)sharedTxtHttp;

- (nullable NSURLSessionDataTask *)GET:(nullable NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

- (nullable NSURLSessionTask *)download:(nullable NSString *)URLString
                            destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                success:(nullable void (^)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath))success
                                failure:(nullable void (^)(NSError * _Nullable error))failure;
@end
