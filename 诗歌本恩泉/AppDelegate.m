//
//  AppDelegate.m
//  诗歌本恩泉
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "AppDelegate.h"
#import "XRTabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import "WXApi.h"
#import "XRHomeViewController.h"
#import "JPUSHService.h"

@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [WXApi registerApp:@"wx988e0897bf675c8b"];
    XRTabBarController *tabBarVC = [[XRTabBarController alloc]init];
    tabBarVC.delegate = self;
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    
    NSError *sessionError = nil;
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&sessionError];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"1161c245d8a09b09583a493a"
                          channel:@"apple"
                 apsForProduction:1
            advertisingIdentifier:nil];
    
    
    //  userInfo为收到远程通知的内容
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        // 有推送的消息，处理推送的消息
        [application setApplicationIconBadgeNumber:0];
        
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarDidChange" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"Search"]) {
        UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = (UINavigationController *)tabBarVC.childViewControllers.firstObject;
        XRHomeViewController *homeVC = [nav.childViewControllers firstObject];
        NSLog(@"%@",homeVC);
        [homeVC searchButtonClick];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
}

- (void)onResp:(BaseResp *)resp
{
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"微信分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case WXErrCodeUserCancel:
                break;
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"微信分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
                
                break;
        }    
    }
}




//获取deviceTocken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSLog(@"%@",deviceToken.description);
    
    [JPUSHService registerDeviceToken:deviceToken];
}

@end
