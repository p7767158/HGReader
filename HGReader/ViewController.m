//
//  ViewController.m
//  HGReader
//
//  Created by zhh on 16/3/4.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "ViewController.h"

#pragma mark - MoreViewController

@interface MoreViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) id dataObject;

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = UIColor.greenColor;
    //self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView loadHTMLString:_dataObject baseURL:nil];
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _webView;
}

@end

@interface ViewController ()<UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *content;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContent];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    self.pageVC.dataSource = self;
    self.pageVC.view.frame = self.view.bounds;
    MoreViewController *initialVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    [_pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageVC];
    [self.view addSubview:self.pageVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initContent
{
    NSMutableArray *pageStrings = @[].mutableCopy;
    for (int i = 1; i < 11; i++) {
        NSString *contentString = [[NSString alloc] initWithFormat:@"chapter %d This is the page %d of content displayed using UIPageViewController in iOS 9.", i, i];
        [pageStrings addObject:contentString];
    }
    self.content = [[NSArray alloc] initWithArray:pageStrings];
}

- (MoreViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (self.content.count == 0  || index >= self.content.count) {
        return nil;
    }
    MoreViewController *dataVC = [[MoreViewController alloc] init];
    dataVC.dataObject = self.content[index];
    return dataVC;
}

- (NSInteger)indexOfViewController:(MoreViewController *)viewController
{
    return [self.content indexOfObject:viewController.dataObject];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(MoreViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(MoreViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.content.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end

















