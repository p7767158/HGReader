//
//  HGRecommendBookListCell.h
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const recommendBookListCell = @"recommendBookListCell";

@class HGBook;
@interface HGRecommendBookListCell : UITableViewCell

- (void)updateWithBook:(HGBook *)book;

@end
