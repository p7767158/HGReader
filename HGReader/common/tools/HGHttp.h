//
//  HGHttp.h
//  HGReader
//
//  Created by zhh on 16/3/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString const * kHttpSubfix = @"&deviceid=6A1DBD4F-3726-4944-B557-6F9157C77138&ver=1.3.0&build=1.3.0&lan=zh&ua=ios&platform=ios&chan=1&appid=1037583098&qd=1001";
static NSString const * kRecommendApi = @"http://qishu.easebook.cn/api/v2/book/recommend?page=%@&page.size=20&uid=";

@interface HGHttp : NSObject

- (instancetype)sharedHttp;

@end
