//
//  HHWebImageManager.h
//  HGReader
//
//  Created by zhh on 16/4/7.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>

@interface HHWebImageManager : SDWebImageManager

+ (HHWebImageManager *)sharedManager;

- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                            blur:(BOOL)blur
                                         options:(SDWebImageOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;

@end
