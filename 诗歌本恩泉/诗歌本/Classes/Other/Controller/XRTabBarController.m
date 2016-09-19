//
//  XRTabBarController.m
//  worship
//
//  Created by Ru on 12/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRTabBarController.h"
#import "XRHomeViewController.h"
#import "XRColletionViewController.h"
#import "XRDownLoadController.h"
#import "XRNavigationController.h"
#import "XRSettingViewController.h"
@interface XRTabBarController ()

@end

@implementation XRTabBarController

//+(void)initialize
//{
////    UITabBarItem *item = [UITabBarItem appearance];
////    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
////    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0];
////    
////    NSMutableDictionary *selAttrs = [NSMutableDictionary dictionary];
////    selAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:229.0/255 green:77.0/255 blue:66.0/255 alpha:1.0];
////    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
////    [item setTitleTextAttributes:selAttrs forState:UIControlStateSelected];
//    
//
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    XRHomeViewController *homeVC = [[XRHomeViewController alloc]init];
    [self setupChildVC:homeVC title:@"目录" image:@"Home" selectecImage:@"HomeSel"];
    
    XRColletionViewController *collectionVC = [[XRColletionViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    [self setupChildVC:collectionVC title:@"收藏" image:@"Star" selectecImage:@"StarSel"];
    
    
    XRDownLoadController *downloadVC = [[XRDownLoadController alloc]init];
    [self setupChildVC:downloadVC title:@"下载" image:@"Download" selectecImage:@"DownloadSel"];
    
    XRSettingViewController *settingVC = [[XRSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self setupChildVC:settingVC title:@"设置" image:@"Settings" selectecImage:@"Settings"];
    
    [self.tabBar setTintColor:[UIColor colorWithRed:229.0/255 green:77.0/255 blue:66.0/255 alpha:1.0]];
    
    
    //恢复常亮设置
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alwaysLight"] == YES) {
        [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
    }
    
 
}


- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectecImage:(NSString *)selectedImage
{
    
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    XRNavigationController *nav = [[XRNavigationController alloc]initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
