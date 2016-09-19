//
//  WebViewController.h
//  诗歌本恩泉
//
//  Created by Ru on 25/6/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
//** url */
@property (nonatomic,copy) NSString *url;

//** 歌曲 */
@property (nonatomic,copy) NSString *song;
// ** webVeiw  */
@property (nonatomic,strong) UIWebView *webview;
@end
