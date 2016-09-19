//
//  XRPopTableViewController.h
//  诗歌本恩泉
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRPopTableViewController;
@protocol XRPopTableViewControllerDelegate <NSObject>

- (void)PopTableViewControllerDidSelected;

@end

@interface XRPopTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *downloadedList;


@property (nonatomic,weak) id<XRPopTableViewControllerDelegate> delegate;
@end
