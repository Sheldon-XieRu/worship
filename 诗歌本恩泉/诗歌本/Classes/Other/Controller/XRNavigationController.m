//
//  XRNavigationController.m
//  诗歌本恩泉
//
//  Created by Ru on 19/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRNavigationController.h"
#import <SVProgressHUD.h>
@interface XRNavigationController ()

@end


@implementation XRNavigationController


+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [navBar setTitleTextAttributes:attrs];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    
    }
    [super pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [SVProgressHUD dismiss];
   return [super popViewControllerAnimated:animated];
}
@end
