//
//  HGLocalBook.h
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HGLocalBook : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) long long bid;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int currentChapter;
@property (nonatomic, assign) long openTime;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *currentDesc;

- (NSArray *)getBookMarks;
- (NSArray *)getChapterArrays;
- (NSArray *)getPageRanges;
- (void)open:(void (^)(NSString *))finishBlock;

@end
