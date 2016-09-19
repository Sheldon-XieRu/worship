//
//  XRDownloadCell.h
//  诗歌本恩泉
//
//  Created by Ru on 17/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
@class gepu;
@interface XRDownloadCell : UITableViewCell


@property (nonatomic,strong) gepu *gepu;



@property (nonatomic,copy) void (^downLoadButtonPressed)(NSInteger index);

@end
