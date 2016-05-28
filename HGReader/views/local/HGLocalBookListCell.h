//
//  HGLocalBookListCell.h
//  HGReader
//
//  Created by zhh on 16/5/28.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const localBookListCell = @"localBookListCell";

@class HGLocalBook;
@interface HGLocalBookListCell : UITableViewCell

- (void)updateWithLocalBook:(HGLocalBook *)localBook;

@end
