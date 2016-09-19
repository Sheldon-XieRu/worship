//
//  XRHomeViewController.h
//  诗歌本
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
@interface XRHomeViewController : UITableViewController

// ** 存  */
@property (nonatomic,strong) WebViewController *webViewController;
- (void)searchButtonClick;
@end
