//
//  gepu.h
//  诗歌本恩泉
//
//  Created by Ru on 19/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gepu : NSObject
//** 名字 */
@property (nonatomic,copy) NSString *name;

//** url */
@property (nonatomic,copy) NSString *url;

//** image */
@property (nonatomic,copy) NSString *image;

// ** <#注释#> */
@property (nonatomic,assign) CGFloat progress;//下载进度

+ (NSArray *)gepuList;
@end
