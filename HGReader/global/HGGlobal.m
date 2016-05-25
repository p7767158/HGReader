//
//  HGGlobal.m
//  HGReader
//
//  Created by zhh on 16/3/4.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGGlobal.h"

@implementation HGGlobal

+ (UIFont *)defaultFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
}

+ (NSAttributedString *)makeAttString:(NSString *)str withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing withColor:(UIColor *)color
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    if (!str) {
        str = @"";
    }
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSParagraphStyleAttributeName:paragraphStyle,
                                                        NSFontAttributeName:font,
                                                        NSForegroundColorAttributeName:color
                                                        }];
}

+ (long)now
{
    return ceil([[NSDate date] timeIntervalSince1970]);
}

@end
