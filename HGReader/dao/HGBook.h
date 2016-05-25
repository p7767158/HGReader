//
//  HGBook.h
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class HGLocalBook;
@interface HGBook : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) long long bid;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) double createDate;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) long zipFileSize;
@property (nonatomic, assign) long txtFileSize;
@property (nonatomic, assign) long seq;
@property (nonatomic, assign) long chapterNum;
@property (nonatomic, copy) NSString *searchCount;
@property (nonatomic, assign) int bookType;
@property (nonatomic, copy) NSString *nbpSize;

+ (void)getBooksByPage:(NSInteger)page succ:(void (^)(NSArray *, NSString *))succBlock fail:(void(^)())failBlock;
+ (void)tryReadByBid:(long long)bid succ:(void (^)(NSString *))succBlock fail:(void(^)())failBlock;
+ (void)downloadByBook:(HGBook *)book succ:(void (^)(HGLocalBook *))succBlock fail:(void(^)())failBlock;;
- (NSString *)filePath;
- (void)saveWithData:(NSData *)data;
- (void)saveChapterArray:(NSArray *)chapterArray;
- (void)savePageRanges:(NSArray *)pageRanges;

@end
