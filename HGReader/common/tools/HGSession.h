//
//  HGSession.h
//  HGReader
//
//  Created by zhh on 16/5/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kBookChaperKey = @"kBookChaperKey";
static NSString * const kBookPageRangesKey = @"kBookPageRangesKey";
static NSString * const kBookMarksKey = @"kBookMarksKey";


@interface HGSession : NSObject

+ (HGSession *)sharedHGSession;
- (void)_initStore;

- (void)setUserDefault:(id)value forKey:(NSString *)key withBid:(long long)bid;
- (id)userDefaultForKey:(NSString *)key withBid:(long long)bid;

@end
