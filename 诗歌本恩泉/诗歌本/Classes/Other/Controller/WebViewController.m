//
//  WebViewController.m
//  诗歌本恩泉
//
//  Created by Ru on 25/6/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "WebViewController.h"
#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
@interface WebViewController ()<UIActionSheetDelegate,UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webview = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _webview.delegate = self;
    [self.view addSubview:_webview];

   

    NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webview loadRequest:request];
    
     UIBarButtonItem *youkuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Film-100"] style:UIBarButtonItemStylePlain target:self action:@selector(searchYouku)];
    self.navigationItem.rightBarButtonItem = youkuItem;
    
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)searchYouku
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"土豆(视频)",@"赞美诗网",@"九酷音乐",nil];
    [actionSheet showInView:self.view];
    actionSheet.delegate =self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //        http://www.soku.com/m/t/video?q=
        
        NSString *songName =self.song;
        NSString *urlString = [@"http://m.soku.com/m/t/video?q=" stringByAppendingString:songName];
        urlString = [urlString stringByAppendingString:@" 赞美"];
        //    urlString = [urlString stringByAppendingString:@"&filter=1"];
        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webview loadRequest:request];
    }
    if (buttonIndex == 1) {
        NSString *songName = self.song;
        NSString *urlString = [@"http://www.zanmeishi.com/search/song/" stringByAppendingString:songName];
        //    urlString = [urlString stringByAppendingString:@"&filter=1"];
        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webview loadRequest:request];
    }
    if (buttonIndex == 2) {
       
        NSString *songName = self.song;
        NSString *urlString = [@"http://baidu.9ku.com/fuyin/" stringByAppendingString:songName];
        //    urlString = [urlString stringByAppendingString:@"&filter=1"];
        urlString = [urlString stringByAppendingPathComponent:@"0"];
        NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webview loadRequest:request];
    }
}

- (void)orientationDidChange
{
    self.webview.frame = [UIScreen mainScreen].bounds;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [SVProgressHUD dismiss];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
    self.webview = nil;
    [SVProgressHUD dismissWithDelay:2];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

@end
