//
//  HGHomeTabBarController.m
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGHomeTabBarController.h"
#import "HGRecommendBooksViewController.h"
#import "HGLocalBookListViewController.h"

@implementation HGHomeTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        HGLocalBookListViewController *localBooksVC = [[HGLocalBookListViewController alloc] init];
        UINavigationController *localNavVC = [[UINavigationController alloc] initWithRootViewController:localBooksVC];
        localNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"书架" image:nil selectedImage:nil];
        
        HGRecommendBooksViewController *recBooksVC = [[HGRecommendBooksViewController alloc] init];
        UINavigationController *recNavVC = [[UINavigationController alloc] initWithRootViewController:recBooksVC];
        recNavVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:nil selectedImage:nil];
        
        [self setViewControllers:@[localNavVC, recNavVC]];
    }
    return self;
}

@end
