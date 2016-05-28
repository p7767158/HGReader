//
//  HGLocalBookListCell.m
//  HGReader
//
//  Created by zhh on 16/5/28.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGLocalBookListCell.h"
#import "HGLocalBook.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface HGLocalBookListCell ()

@property (nonatomic, strong) UIImageView *coverImg;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *descLb;
@property (nonatomic, strong) UILabel *chapterLb;
@property (nonatomic, strong) HGLocalBook *localBook;

@end

@implementation HGLocalBookListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.nameLb];
        [self.contentView addSubview:self.chapterLb];
        [self.contentView addSubview:self.descLb];
        
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 140));
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImg.mas_right).offset(10);
            make.top.equalTo(self.coverImg).offset(5);
        }];
        
        [self.chapterLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLb.mas_bottom).offset(10);
            make.left.equalTo(self.nameLb);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chapterLb.mas_bottom).offset(10);
            make.left.equalTo(self.chapterLb);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}


- (UILabel *)nameLb
{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc] init];
        _nameLb.font = [UIFont systemFontOfSize:18];
    }
    return _nameLb;
}

- (UIImageView *)coverImg
{
    if (!_coverImg) {
        _coverImg = [[UIImageView alloc] init];
    }
    return _coverImg;
}

- (UILabel *)descLb
{
    if (!_descLb) {
        _descLb = [[UILabel alloc] init];
        _descLb.font = [UIFont systemFontOfSize:14];
        _descLb.textColor = [HGColor textColor];
        _descLb.numberOfLines = 4;
    }
    return _descLb;
}

- (UILabel *)chapterLb
{
    if (!_chapterLb) {
        _chapterLb = [[UILabel alloc] init];
        _chapterLb.font = [UIFont systemFontOfSize:14];
        _chapterLb.textColor = [HGColor textColor];
    }
    return _chapterLb;
}

- (void)updateWithLocalBook:(HGLocalBook *)localBook
{
    self.localBook = localBook;
    self.nameLb.text = localBook.name;
    [self.coverImg setImageWithURL:[NSURL URLWithString:localBook.coverUrl]];
    self.descLb.text = [NSString stringWithFormat:@"           %@", localBook.currentDesc];
    NSArray *chapterArray = [localBook getChapterArrays];
    NSDictionary *chapter = chapterArray[localBook.currentChapter];
    if ([chapter[@"title"] length] > 0) {
        self.chapterLb.text = [NSString stringWithFormat:@"读至：%@", chapter[@"title"]];
    }
}

@end
