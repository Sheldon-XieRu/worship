//
//  XRShowGepuViewController.m
//  诗歌本恩泉
//
//  Created by Ru on 23/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRShowGepuViewController.h"
#import "UIView+XMGExtension.h"
#import "XRHomeViewController.h"
#import "XRColletionViewController.h"
#import <SVProgressHUD.h>
#import <Masonry.h>
#import "WebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extension.h"
#import "WXApi.h"
@interface XRShowGepuViewController ()<UIActionSheetDelegate>

@property (nonatomic,weak) UIImageView *songImageView;

@property (nonatomic,weak) UIScrollView *scrollView;

// ** 收藏按钮 * /
@property (nonatomic,weak) UIButton *starButton;

// ** webviewController  */
@property (nonatomic,strong) WebViewController *webViewController;


@property (nonatomic,assign) NSInteger lastButtonIndex;

// ** 是否被收藏 */
@property (nonatomic,assign) BOOL collected;


// ** size */
@property (nonatomic,assign) CGSize thumbSize;
@end

@implementation XRShowGepuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = self.song;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];


//    scrollView.frame = self.view.bounds;
    

    scrollView.backgroundColor =[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    

    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [starButton setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
    [starButton setImage:[UIImage imageNamed:@"StarSel"] forState:UIControlStateSelected];

    
    [starButton sizeToFit];
    
    self.starButton = starButton;
    
    [starButton addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    
    [self checkForCollectionState];
    
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithCustomView:starButton];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:starButton];
//    UIBarButtonItem *youkuItem = [[UIBarButtonItem alloc]initWithTitle:@"视频" style:UIBarButtonItemStylePlain target:self action:@selector(searchYouku)];
    UIBarButtonItem *youkuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Film-100"] style:UIBarButtonItemStylePlain target:self action:@selector(searchYouku)];
    

    self.navigationItem.rightBarButtonItems = @[youkuItem,collectItem];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    [self loadImage];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];

    
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.tag = 0;
    [shareButton setImage:[UIImage imageNamed:@"convenient_share_wx"] forState:UIControlStateNormal];
    [self.view addSubview:shareButton];
    shareButton.alpha = 0.7;
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *timeLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeLineButton setImage:[UIImage imageNamed:@"convenient_share_pyq"] forState:UIControlStateNormal];
    [self.view addSubview:timeLineButton];
    [timeLineButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    timeLineButton.alpha = 0.7;
    [timeLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(shareButton.mas_left).offset(-10);
        make.bottom.equalTo(shareButton.mas_bottom);
    }];
    timeLineButton.tag = 1;
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}
- (void)loadImage
{
    
    UIImageView *songImageView = [[UIImageView alloc]init];
    
    NSString *imageName = [self.song stringByAppendingString:@".jpg"];
    //图片导入
    UIImage *gepuImage = nil;
    if ([self.gepu isEqualToString:@"恩泉佳音"]) {
        gepuImage = [UIImage imageNamed:imageName];
    }else{
        NSString *gepuPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:self.gepu];
        if ([self.gepu isEqualToString:@"恩泉佳音续一"] ) {
            gepuPath = [gepuPath stringByDeletingLastPathComponent];
        }
        gepuPath = [gepuPath stringByAppendingPathComponent:self.gepu];
        
       
        
        NSString *songPath = [gepuPath stringByAppendingPathComponent:imageName];
   
        
        if ([self.gepu isEqualToString:@"赞美诗歌1218"]) {
           songPath = [songPath stringByDeletingPathExtension];
        }

        gepuImage = [UIImage imageWithContentsOfFile:songPath];
    }

    songImageView.image = gepuImage;
    self.songImageView = songImageView;
    
    
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat showImageW = screenW;
    CGFloat showImageH = showImageW * gepuImage.size.height / gepuImage.size.width;
    
    self.thumbSize = CGSizeMake(0.5 * showImageW, 0.5 * showImageH);
    
    
    if (showImageH > screenH) {
        songImageView.frame = CGRectMake(0, 0, showImageW, showImageH);
        self.scrollView.contentSize = CGSizeMake(0, showImageH);
    }else{
        songImageView.size = CGSizeMake(showImageW, showImageH);
        songImageView.centerY = 0.5 * (screenH-64);
        
    }
    [self.scrollView addSubview:songImageView];


}


- (void)collect{

    if (self.collected) {//已收藏 取消收藏
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        path = [path stringByAppendingString:@"savedsongs.plist"];
        NSArray *allArray = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *songDict in allArray) {
            [songDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:self.gepu]) {
                    NSMutableArray *songsArray = obj;
                    [songsArray removeObject:self.song];
                }
            }];
        }
        
        [allArray writeToFile:path atomically:YES];
        !self.didCancelBlock ? : self.didCancelBlock();
        self.starButton.selected = NO;
        self.collected = NO;
        [SVProgressHUD showInfoWithStatus:@"取消成功"];
    
        
    }else{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        path = [path stringByAppendingString:@"savedsongs.plist"];
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
        //如果没有创建
        if (array == nil) {
            array = [NSMutableArray array];
            [array addObject:@{self.gepu : [NSArray arrayWithObject:self.song]}];
            [array writeToFile:path atomically:YES];
        }else{
            BOOL find = NO;
            for (NSMutableDictionary *dict in array) {
                if (dict[self.gepu]) {//有歌谱
                    NSMutableArray *songsArray = dict[self.gepu];
                    //检查是否已收藏
                    if ([songsArray containsObject:self.song])
                    {
                        
                        [SVProgressHUD showInfoWithStatus:@"该首歌已收藏"];
                        return;
                    }
                    [songsArray addObject:self.song];
                    dict[self.gepu] = songsArray;
                    find = YES;
                }
            }
            if (find == NO) {
                [array addObject:@{self.gepu:[NSArray arrayWithObject:self.song]}];
            }
            
            [array writeToFile:path atomically:YES];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"didCollect" object:nil];
            
            [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
            self.starButton.selected = YES;
            self.collected = YES;
        }
    }
    

}


- (void)searchYouku
{
    
    if (self.webViewController && self.lastButtonIndex != 0) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"土豆(视频)",@"赞美诗网",nil];
        [actionSheet showInView:self.view];
        actionSheet.delegate =self;
        
        
    }
    


    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"%@",self.webViewController);
    [self.webViewController.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    if (buttonIndex == 0) {
//        http://www.soku.com/m/t/video?q=
        NSUInteger index = [self indexOfFirstChn:self.song];
        NSString *songName = [self.song substringFromIndex:index];
        NSString *urlString = [@"http://m.soku.com/m/t/video?q=" stringByAppendingString:songName];
        urlString = [urlString stringByAppendingString:@" 赞美"];
        //    urlString = [urlString stringByAppendingString:@"&filter=1"];
        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _webViewController = [[WebViewController alloc]init];
        _webViewController.song = songName;
        _webViewController.url = url;
        [self.navigationController pushViewController:_webViewController animated:YES];
    }
    if (buttonIndex == 1) {
        NSUInteger index = [self indexOfFirstChn:self.song];
        NSString *songName = [self.song substringFromIndex:index];
        NSString *urlString = [@"http://www.zanmeishi.com/search/song/" stringByAppendingString:songName];
        //    urlString = [urlString stringByAppendingString:@"&filter=1"];
        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _webViewController = [[WebViewController alloc]init];
        _webViewController.song = songName;
        _webViewController.url = url;
//        UINavigationController *nav = (UINavigationController *)self.parentViewController;
//        
//        
//        id viewController = nav.childViewControllers[0];
//        
////        XRHomeViewController *homeVC = nav.childViewControllers[0];
//        [viewController setValue:viewController forKeyPath:@"webViewController"];
        UINavigationController *nav = (UINavigationController *)self.parentViewController;
        XRHomeViewController *homeVC = nav.childViewControllers[0];
        homeVC.webViewController = _webViewController;
        [self.navigationController pushViewController:_webViewController animated:YES];
    }
//    if (buttonIndex == 2) {
//        NSUInteger index = [self indexOfFirstChn:self.song];
//        NSString *songName = [self.song substringFromIndex:index];
//        NSString *urlString = [@"http://baidu.9ku.com/fuyin/" stringByAppendingString:songName];
//        //    urlString = [urlString stringByAppendingString:@"&filter=1"];
//        urlString = [urlString stringByAppendingPathComponent:@"0"];
//        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        _webViewController = [[WebViewController alloc]init];
//        _webViewController.song = songName;
//        _webViewController.url = url;
//        UINavigationController *nav = (UINavigationController *)self.parentViewController;
//        XRHomeViewController *homeVC = nav.childViewControllers[0];
//        homeVC.webViewController = _webViewController;
//        
//        [self.navigationController pushViewController:_webViewController animated:YES];
//    }
    self.lastButtonIndex = buttonIndex;
    
}

- (NSUInteger)indexOfFirstChn:(NSString *)songName
{
    int i = 0;
    for (i = 0; i < songName.length; i++) {
        if ([[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"1"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"2"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"3"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"4"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"5"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"6"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"7"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"8"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"9"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"0"]
            ||[[songName substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"b"]
            ){
            continue;
        }else{
            return i;
        };
        
    }
    
    return i;
}


- (void)checkForCollectionState
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    path = [path stringByAppendingString:@"savedsongs.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    //如果没有创建

      
        for (NSMutableDictionary *dict in array) {
            if (dict[self.gepu]) {//有歌谱
                NSMutableArray *songsArray = dict[self.gepu];
                //检查是否已收藏
                if ([songsArray containsObject:self.song])
                {
                    
                    self.starButton.selected = YES;
                    self.collected = YES;
             
                }

            
            }
        }

}



- (void)share:(UIButton *)button
{
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showInfoWithStatus:@"您尚未安装微信"];
        return;
    }else {
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        
        
        WXMediaMessage *media = [[WXMediaMessage alloc]init];
        
        
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = UIImagePNGRepresentation(self.songImageView.image);
        media.mediaObject = imageObject;

        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [media setThumbImage:[self.songImageView.image imageByScalingAndCroppingForSize:self.thumbSize]];
        }

        media.description = @"fff";
        
        
        //        sendReq.bText = YES;//YES表示使用文本信息 NO表示不使用文本信息
        //        sendReq.text = @" 大傻妞妞";
        sendReq.message = media;
        // 0：分享到好友列表 1：分享到朋友圈  2：收藏
        sendReq.scene = (int)button.tag;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
        
        // 返回分享成功还是失败
//        NSLog(@" 成功和失败 - %d",[WXApi sendReq:sendReq]);
        
        
//        WXMediaMessage *message = [[WXMediaMessage alloc]init];
//        message.title = @"一起来敬拜主吧!";
//        message.description = @"下载诗歌本，一起来敬拜赞美我们伟大的神";
//        message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"message"]);
//        
//        WXWebpageObject *webObject = [WXWebpageObject object];
//        webObject.webpageUrl = @"https://itunes.apple.com/cn/app/ji-du-tu-jing-bai-zan-mei/id1110726577?mt=8";
//        message.mediaObject = webObject;
//        
//        
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
//        req.message = message;
//        req.scene =  (int)indexPath.row;
//        [WXApi sendReq:req];
    }
    
}

- (void)orientationDidChange
{
    [self viewDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

}



@end
