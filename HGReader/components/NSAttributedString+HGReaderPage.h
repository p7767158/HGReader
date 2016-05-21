//
//  NSAttributedString+HGReaderPage.h
//  HGReader
//
//  Created by zhh on 16/5/21.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (HGReaderPage)

- (NSArray *)pageRangeArrayWithConstrainedToSize:(CGSize)size;

@end
