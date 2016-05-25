//
//  AppDelegate.m
//  HGReader
//
//  Created by zhh on 16/3/4.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "AppDelegate.h"
#import "HGHomeTabBarController.h"
#import "HGSession.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //NSString *path = [NSString stringWithFormat:@"%@/Documents/myData.text",NSHomeDirectory()];
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/%d.txt",NSHomeDirectory(), 35897];
////    NSString *path = @"/Users/zhh/Desktop/35896.txt";
//    NSLog(@"%@",path);
//    NSStringEncoding enc;
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    
////    for (int i = 1; i<= 40; i++) {
////        NSStringEncoding sosoEncoding = CFStringConvertEncodingToNSStringEncoding(i);
////        NSString *str = [[NSString alloc] initWithData:data encoding:sosoEncoding];
////        NSLog(@"%dzzzzzzzzzzzzzzzzzz%@", i, str);
////    }
//    
//    
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF16LittleEndianStringEncoding];
//    string = [NSString stringWithContentsOfFile:path encoding:enc error:nil];
    
    [[HGSession sharedHGSession] _initStore];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HGHomeTabBarController *homeController = [[HGHomeTabBarController alloc] init];
    self.window.rootViewController = homeController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
