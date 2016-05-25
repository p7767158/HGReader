//
//  HGLocalBook.m
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGLocalBook.h"
#import "HGSession.h"

@implementation HGLocalBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"bid"            :@"bid",
             @"author"         :@"author",
             @"name"           :@"name",
             @"filePath"       :@"filePath",
             @"currentPage"    :@"currentPage",
             @"currentChapter" :@"currentChapter",
             @"openTime"       :@"openTime",
             @"coverUrl"       :@"coverUrl",
             @"currentDesc"    :@"currentDesc"
             };
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

- (NSArray *)getBookMarks
{
    return [[HGSession sharedHGSession] userDefaultForKey:kBookMarksKey withBid:self.bid];
}

- (NSArray *)getChapterArrays
{
    return [[HGSession sharedHGSession] userDefaultForKey:kBookChaperKey withBid:self.bid];
}

- (NSArray *)getPageRanges
{
    return [[HGSession sharedHGSession] userDefaultForKey:kBookPageRangesKey withBid:self.bid];
}

- (void)open:(void (^)(NSString *))finishBlock
{
    NSString *str = [NSString stringWithContentsOfFile:[self filePath]  encoding:NSUTF16LittleEndianStringEncoding error:nil];
    finishBlock(str);
}

@end
