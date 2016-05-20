//
//  HGRecommendBookListCell.m
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGRecommendBookListCell.h"
#import "HGBook.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface HGRecommendBookListCell()

@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *authorLb;
@property (nonatomic, strong) UILabel *summaryLb;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIView *sep;

@end

@implementation HGRecommendBookListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.nameLb];
        [self.contentView addSubview:self.authorLb];
        [self.contentView addSubview:self.summaryLb];
        [self.contentView addSubview:self.countLb];
        
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 140));
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImg.mas_right).offset(15);
            make.top.equalTo(self.coverImg);
        }];
        
        [self.authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).offset(15);
            make.right.lessThanOrEqualTo(self.contentView);
        }];
        
        [self.summaryLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLb.mas_bottom).offset(20);
            make.left.equalTo(self.coverImg.mas_right).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (UIImageView *)coverImg
{
    if (!_coverImg) {
        _coverImg = [[UIImageView alloc] init];
        _coverImg.backgroundColor = [UIColor lightGrayColor];
    }
    return _coverImg;
}

- (UILabel *)nameLb
{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
    }
    return _nameLb;
}

- (UILabel *)authorLb
{
    if (!_authorLb) {
        _authorLb = [[UILabel alloc] init];
        _authorLb.font = [UIFont systemFontOfSize:15];
        _authorLb.textColor = [UIColor darkGrayColor];
    }
    return _authorLb;
}

- (UILabel *)summaryLb
{
    if (!_summaryLb) {
        _summaryLb = [[UILabel alloc] init];
        _summaryLb.numberOfLines = 5;
        _summaryLb.textColor = [UIColor grayColor];
        _summaryLb.font = [UIFont systemFontOfSize:14];
    }
    return _summaryLb;
}

- (UILabel *)countLb
{
    if (!_countLb) {
        _countLb = [[UILabel alloc] init];
    }
    return _countLb;
}

- (UIView *)sep
{
    if (!_sep) {
        _sep = [[UIView alloc] init];
        _sep.backgroundColor = [UIColor lightGrayColor];
    }
    return _sep;
}

- (void)updateWithBook:(HGBook *)book
{
    if (book.coverUrl.length > 0) {
        [self.coverImg setImageWithURL:[NSURL URLWithString:book.coverUrl]];
    }
    self.nameLb.text = book.name;
    self.authorLb.text = book.author;
    self.summaryLb.text = book.summary;
    self.countLb.text = book.searchCount;
}

@end
