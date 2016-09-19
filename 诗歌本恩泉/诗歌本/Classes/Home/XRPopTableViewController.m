//
//  XRPopTableViewController.m
//  诗歌本恩泉
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRPopTableViewController.h"
#import "XRPopTableViewCell.h"
#import "gepu.h"
@interface XRPopTableViewController ()


@property (nonatomic,strong) NSArray *gepuList;



@end

@implementation XRPopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.layer.borderWidth = 3;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.cornerRadius = 20;
    self.tableView.layer.masksToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XRPopTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"gepuCell"];


//       NSIndexPath *indexPath = [NSIndexPath indexPathForRow: [self.gepuList indexOfObject:@"恩泉佳音"] inSection:0];
//    NSLog(@"%zd",indexPath.row);
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.downloadedList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XRPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gepuCell"];
    cell.gepuName = [self.downloadedList[indexPath.row] name];
    
    return cell;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selGepu = [self.downloadedList[indexPath.row] name];
    [[NSUserDefaults standardUserDefaults] setObject:selGepu forKey:@"selectedGepu"];
    
    if ([self.delegate respondsToSelector:@selector(PopTableViewControllerDidSelected)]) {
        [self.delegate PopTableViewControllerDidSelected];
    }
    
    [self.tableView reloadData];
    
    
}


@end
