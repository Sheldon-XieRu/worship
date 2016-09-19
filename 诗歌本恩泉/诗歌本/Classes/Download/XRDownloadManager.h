//
//  XRDownloadManager.h
//  诗歌本恩泉
//
//  Created by Ru on 18/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XRDownloadManager;

@protocol XRDownloadManagerDelegate <NSObject>

@optional
- (void)downloadManagerDidUpdateProgress:(CGFloat)progress;
- (void)downloadManagerDidCompleteDownloadWithOriginal:(NSString *)originalPath FilefolderPath:(NSString *)filefolderPath;
@end

@interface XRDownloadManager : NSObject

- (void)downloadWithUrl:(NSString *)url fileName:(NSString *)fileName;


@property (nonatomic,weak) id <XRDownloadManagerDelegate> delegate;

@end
