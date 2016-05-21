//
//  NSAttributedString+HGReaderPage.m
//  HGReader
//
//  Created by zhh on 16/5/21.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "NSAttributedString+HGReaderPage.h"

@implementation NSAttributedString (HGReaderPage)

- (NSArray *)pageRangeArrayWithConstrainedToSize:(CGSize)size
{
    NSAttributedString *attributedString = self;
    NSMutableArray * resultRange = [NSMutableArray array];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //    以下方法耗时 基本再 0.5s 以内
    // NSDate * date = [NSDate date];
    NSInteger rangeIndex = 0;
    do {
        NSUInteger length = MIN(600, attributedString.length - rangeIndex);
        NSAttributedString * childString = [attributedString attributedSubstringFromRange:NSMakeRange(rangeIndex, length)];
        CTFramesetterRef childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:rect];
        CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, (__bridge CFDictionaryRef)[self attributesAtIndex:0 effectiveRange:nil]);
        
        CFRange range = CTFrameGetVisibleStringRange(frame);
        NSRange r = {rangeIndex, range.length};
        if (r.length > 0) {
            [resultRange addObject:[NSValue valueWithRange:r]];
        }
        rangeIndex += r.length;
        CFRelease(frame);
        CFRelease(childFramesetter);
    } while (rangeIndex < attributedString.length && attributedString.length > 0);
    //NSTimeInterval millionSecond = [[NSDate date] timeIntervalSinceDate:date];
    //NSLog(@"耗时 %lf", millionSecond);
    return resultRange;
}

@end
