//
//  HGBook.m
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGBook.h"
#import "HGHttp.h"
#import "HGBookDB.h"
#import <SSZipArchive/SSZipArchive.h>
#import "HGSession.h"
#import "HGLocalBook.h"

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

- (NSString *)filePath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:[NSString stringWithFormat:@"%@/Documents/books", NSHomeDirectory()]]) {
        [fileMgr createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/books", NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *path = [NSString stringWithFormat:@"%@/Documents/books/%@.txt", NSHomeDirectory(), self.name];
    return path;
}

- (void)readBook:(HGBook *)book finishBlock:(void (^)(NSString *))finishBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfFile:[book filePath]];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding];
        finishBlock(string);
    });
}

- (void)saveWithData:(id)data completion:(void (^)())completion
{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%lld.zip",NSHomeDirectory(), self.bid];
    NSString *destinationPath = [NSString stringWithFormat:@"%@/Documents/%lld",NSHomeDirectory(), self.bid];
    NSLog(@"%@",path);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    const void *buffer = NULL;
    size_t size = 0;
    dispatch_data_t new_data_file = dispatch_data_create_map(data, &buffer, &size);
    dispatch_data_t _data = dispatch_data_create(buffer, size, queue, NULL);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_fd_t fd = open(path.UTF8String,  O_RDWR | O_CREAT | O_TRUNC, S_IRWXU | S_IRWXG | S_IRWXO);
    dispatch_write(fd, _data, queue, ^(dispatch_data_t d, int error) {
        //printf("Written %zu bytes!\n", dispatch_data_get_size(d));
        printf("\tError: %d\n", error);
        dispatch_semaphore_signal(sem);
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    close(fd);
    
    BOOL unZip = [SSZipArchive unzipFileAtPath:path toDestination:destinationPath];
    
    if (unZip) {
        //拿到未经处理的string
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%lld.txt", destinationPath, self.bid]];
        NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding];
        [HGBook addFirstLineWithStr:tempString isSaveChapter:YES finishBlock:^(NSString *text, NSArray *chapterArray) {
            //将添加了首行缩进的string,保存到本地
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            if (![fileMgr fileExistsAtPath:[self filePath]]) {
                NSError *error;
                if ([text writeToFile:[self filePath] atomically:NO encoding:NSUTF16LittleEndianStringEncoding error:&error]) {
                    NSLog(@"%@: 保存到本地成功", self.name);
                    if ([fileMgr fileExistsAtPath:path]) {
                        if ([fileMgr removeItemAtPath:path error:nil] && [fileMgr removeItemAtPath:destinationPath error:nil]) {
                            NSLog(@"%@: 解压成功", self.name);
                        } else {
                            NSLog(@"%@: 解压失败", self.name);
                        }
                    }
                    //save book to db
                    [[HGBookDB sharedHGBookDB] saveBook:self];
                    
                    //save info of chapter to userDefaults
                    [self saveChapterArray:chapterArray];
                    
                    //所有保存工作进行完毕
                    completion();
                }
                if (error) {
                    NSLog(@"save error");
                }
            }
        }];
    }
}

- (void)saveChapterArray:(NSArray *)chapterArray
{
    [[HGSession sharedHGSession] setUserDefault:chapterArray forKey:kBookChaperKey withBid:self.bid];
}
- (void)savePageRanges:(NSArray *)pageRanges
{
    [[HGSession sharedHGSession] setUserDefault:pageRanges forKey:kBookPageRangesKey withBid:self.bid];
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
        [HGBook addFirstLineWithStr:str isSaveChapter:NO finishBlock:^(NSString *str, NSArray *chapterArray) {
            succBlock(str);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        failBlock();
    }];
}

+ (void)downloadByBook:(HGBook *)book succ:(void (^)(HGLocalBook *))succBlock fail:(void (^)())failBlock
{
    [[HGHttp sharedTxtHttp] GET:[NSString stringWithFormat:kDownloadApi, book.bid, kHttpSubfix] parameters:nil progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"%@", progress);
    } success:^(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable data) {
        [book saveWithData:data completion:^{
            //保存完毕打开图书
            [[HGBookDB sharedHGBookDB] getBookWithBid:book.bid finishBlock:^(NSDictionary *books) {
                HGLocalBook *localBook = books[@(book.bid)];
                NSLog(@"打开：%@ 成功", localBook.name);
                succBlock(localBook);
            }];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        failBlock();
    }];
}

+ (void)addFirstLineWithStr:(NSString *)str isSaveChapter:(BOOL)save finishBlock:(void (^)(NSString *, NSArray *))finishBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableString *text = @"        ".mutableCopy;
        NSMutableArray *chapterArray = @[].mutableCopy;
        [[str componentsSeparatedByString:@"\n"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (obj.length > 0) {
                
                //judge chapter
                if (save && [obj hasPrefix:@"第"] && [[obj componentsSeparatedByString:@" "][0] hasSuffix:@"章"]) {
                    //add info of chapter to NSArray(chapter)
                    NSRange range = [str rangeOfString:obj];
                    if (range.location != NSNotFound) {
                        [chapterArray addObject:@{@"title":obj, @"range":[NSString stringWithFormat:@"%lu,%lu", (unsigned long)range.location, (unsigned long)range.length]}];
                    }
                }
                [text appendString:obj];
                [text appendString:@"\n        "];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            finishBlock(text, chapterArray);
        });
    });
}

@end
