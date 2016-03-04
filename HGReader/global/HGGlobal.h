//
//  HGGlobal.h
//  HGReader
//
//  Created by zhh on 16/3/4.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGGlobal : NSObject

#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname)\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[super allocWithZone:NULL] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self shared##classname];\
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\

#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@end
