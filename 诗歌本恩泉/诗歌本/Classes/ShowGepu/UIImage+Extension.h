//
//  UIImage+Extension.h
//  诗歌本恩泉
//
//  Created by Ru on 23/7/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)roundedImage;
@end
