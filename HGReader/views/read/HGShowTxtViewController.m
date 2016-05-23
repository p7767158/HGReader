//
//  HGShowTxtViewController.m
//  HGReader
//
//  Created by zhh on 16/5/21.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGShowTxtViewController.h"

@interface HGShowTxtViewController()

@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UILabel *pageLabel;

@end

@implementation HGShowTxtViewController

- (instancetype)initWithAttTxt:(NSAttributedString *)txt withPageTxt:(NSAttributedString *)pageTxt
{
    if (self = [super init]) {
        self.showLabel.attributedText = txt;
        self.pageLabel.attributedText = pageTxt;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showLabel];
    [self.view addSubview:self.pageLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-18);
    }];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.centerX.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UILabel *)showLabel
{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.numberOfLines = 0;
        _showLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _showLabel;
}

- (UILabel *)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
    }
    return _pageLabel;
}

@end
