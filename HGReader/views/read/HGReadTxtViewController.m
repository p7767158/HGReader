//
//  HGReadTxtViewController.m
//  HGReader
//
//  Created by zhh on 16/5/21.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGReadTxtViewController.h"
#import "NSAttributedString+HGReaderPage.h"
#import "HGShowTxtViewController.h"

static CGFloat kWidthMargin = 40;
static CGFloat kHeightMargin = 70;

@interface HGReadTxtViewController ()<UIPageViewControllerDataSource>

@property (nonatomic, copy) NSAttributedString *txt;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *pageRangeArray;

@property (nonatomic, strong) UIPageViewController *pageVC;

@end

@implementation HGReadTxtViewController

- (instancetype)initWithTxtString:(NSString *)txt
{
    if (self = [super init]) {
        _currentPage = 0;
        _txt = [[NSAttributedString alloc] initWithString:txt attributes:@{
                                                                           NSParagraphStyleAttributeName:self.paragraphStyle,
                                                                           NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize],
                                                                           NSForegroundColorAttributeName:self.textColor}];
        _pageRangeArray = [_txt pageRangeArrayWithConstrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kWidthMargin, [UIScreen mainScreen].bounds.size.height - kHeightMargin)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTapGestureToself];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addTapGestureToself
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBar:)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)showBar:(id)sender
{
    if (self.navigationController.navigationBar.isHidden) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFullScreen:NO];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFullScreen:YES];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFullScreen:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setFullScreen:NO];
}

- (void)setFullScreen:(BOOL)fullScreen
{
    [UIApplication sharedApplication].statusBarHidden = fullScreen;
    [self.navigationController setNavigationBarHidden:fullScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)fontSize
{
    if (!_fontSize) {
        _fontSize = 16;//利用userDefaults
    }
    return _fontSize;
}

- (CGFloat)lineSpacing
{
    if (!_lineSpacing) {
        _lineSpacing = self.fontSize / 2.0;
    }
    return _lineSpacing;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor grayColor];
    }
    return _textColor;
}

- (NSMutableParagraphStyle *)paragraphStyle
{
    if (!_paragraphStyle) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [_paragraphStyle setLineSpacing:self.lineSpacing];
    }
    return _paragraphStyle;
}

- (UIPageViewController *)pageVC
{
    if (!_pageVC) {
        
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
        
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        _pageVC.dataSource = self;
        
        [_pageVC setViewControllers:@[[self getShowTxtVC]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageVC;
}

- (HGShowTxtViewController *)getShowTxtVC
{
    HGShowTxtViewController *showTxtVC = [[HGShowTxtViewController alloc] initWithAttTxt:[self.txt attributedSubstringFromRange:[self.pageRangeArray[self.currentPage] rangeValue]]];
    return showTxtVC;
}

- (NSString *)getShowTxt
{
    return [self.txt.string substringWithRange:[self.pageRangeArray[self.currentPage] rangeValue]];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPage == 0 || self.currentPage == NSNotFound) {
        return nil;
    }
    self.currentPage--;
    return [self getShowTxtVC];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentPage == self.pageRangeArray.count - 1 || self.currentPage == NSNotFound) {
        return nil;
    }
    self.currentPage++;
    return [self getShowTxtVC];
}
@end
