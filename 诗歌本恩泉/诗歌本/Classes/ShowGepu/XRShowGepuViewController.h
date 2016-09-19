//
//  XRShowGepuViewController.h
//  诗歌本恩泉
//
//  Created by Ru on 23/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRShowGepuViewController : UIViewController


//**歌曲 */
@property (nonatomic,copy) NSString *song;

//** 歌谱 */
@property (nonatomic,copy) NSString *gepu;


@property (nonatomic,copy) void (^didCancelBlock)();
@end
