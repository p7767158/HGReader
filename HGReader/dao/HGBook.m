//
//  HGBook.m
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGBook.h"
#import "HGHttp.h"

@implementation HGBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"bid"         :@"id",
             @"author"      :@"author",
             @"createDate"  :@"createDate",
             @"coverUrl"    :@"coverUrl",
             @"name"        :@"name",
             @"summary"     :@"summary",
             @"zipFileSize" :@"zipFileSize",
             @"txtFileSize" :@"txtFileSize",
             @"seq"         :@"seq",
             @"chapterNum"  :@"chapterNum",
             @"searchCount" :@"searchCount",
             @"bookType"    :@"bookType",
             @"nbpSize"     :@"nbpSize"};
}

+ (void)getBooksByPage:(NSInteger)page succ:(void (^)(NSArray *, NSString *))succBlock fail:(void(^)())failBlock
{
    [[HGHttp sharedHttp] GET:[NSString stringWithFormat:kRecommendApi, (long long)page, kHttpSubfix] parameters:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, NSDictionary * _Nullable dictRet) {
        NSArray *books;
        if ([dictRet[@"books"] count] > 0) {
            books = [MTLJSONAdapter modelsOfClass:HGBook.class fromJSONArray:dictRet[@"books"] error:nil];
        }
        succBlock(books, @"请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        failBlock();
    }];
}

+ (void)tryReadByBid:(long long)bid succ:(void (^)(NSString *))succBlock fail:(void(^)())failBlock
{
    [[HGHttp sharedTxtHttp] GET:[NSString stringWithFormat:kTryReadApi, bid, kHttpSubfix] parameters:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable bookTxt) {
        NSString *str = [[NSString alloc] initWithData:bookTxt encoding:NSUTF16LittleEndianStringEncoding];
        succBlock(str);

    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        failBlock();
    }];
}

@end
