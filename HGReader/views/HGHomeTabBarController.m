//
//  HGHomeTabBarController.m
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGHomeTabBarController.h"
#import "HGRecommendBooksViewController.h"

@implementation HGHomeTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        HGRecommendBooksViewController *recBooksVC = [[HGRecommendBooksViewController alloc] init];
        UINavigationController *recNavVC = [[UINavigationController alloc] initWithRootViewController:recBooksVC];
        recNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:nil selectedImage:nil];
        
        [self setViewControllers:@[recNavVC]];
    }
    return self;
}

@end
