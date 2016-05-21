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

@end

@implementation HGShowTxtViewController

- (instancetype)initWithAttTxt:(NSAttributedString *)txt
{
    if (self = [super init]) {
        self.showLabel.attributedText = txt;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.textView];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    [self.view addSubview:self.showLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-18);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        [_textView setContentInset:UIEdgeInsetsMake(10, 10, -10, -10)];
    }
    return _textView;
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

@end
