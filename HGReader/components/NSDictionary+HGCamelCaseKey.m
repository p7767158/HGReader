//
//  NSDictionary+HGCamelCaseKey.m
//  HGReader
//
//  Created by zhh on 16/5/25.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "NSDictionary+HGCamelCaseKey.h"

@implementation NSDictionary (HGCamelCaseKey)

- (NSDictionary *)camelCase
{
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *camelCaseKey ;
        if ([key isKindOfClass:[NSString class]] && [key rangeOfString:@"_"].location != NSNotFound) {
            camelCaseKey = [NSString stringWithFormat:@"%@%@",
                            [key substringToIndex:1], [[[[key stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString] stringByReplacingOccurrencesOfString:@" " withString:@""] substringFromIndex:1]];
        } else {
            camelCaseKey = key;
        }
        ret[camelCaseKey] = obj;
    }];
    return ret;
}

@end
