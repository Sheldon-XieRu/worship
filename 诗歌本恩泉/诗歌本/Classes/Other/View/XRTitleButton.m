//
//  XRTitleButton.m
//  诗歌本恩泉
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRTitleButton.h"

@implementation XRTitleButton






- (void)layoutSubviews
{
    [super layoutSubviews];

    
    self.titleLabel.x = 0;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;



    
}



@end
