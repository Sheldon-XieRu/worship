//
//  XRColletionViewController.m
//  诗歌本
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRColletionViewController.h"

#import "XRShowGepuViewController.h"

@interface XRColletionViewController ()

@property (nonatomic,strong) NSArray *songsArray;


@end

@implementation XRColletionViewController


static NSString * const ID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateCollect) name:@"didCollect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateCollect) name:@"gepuDidDelete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarDidChange) name:@"tabBarDidChange" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.webViewController) {
        UIBarButtonItem *youkuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Film-100"] style:UIBarButtonItemStylePlain target:self action:@selector(searchYouku)];
       
        
        self.navigationItem.rightBarButtonItem = youkuItem;
    }
}

- (void)searchYouku
{
    if (self.webViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.songsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSDictionary *gepuDict = self.songsArray[section];
    
   __block NSArray *detailArray = [NSArray array];
    [gepuDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,NSArray* obj, BOOL * _Nonnull stop) {
       
        detailArray = obj;
        
    }];
    return detailArray.count;
  
}

- (NSArray *)songsArray
{
    if (_songsArray == nil) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        path = [path stringByAppendingString:@"savedsongs.plist"];
        _songsArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _songsArray;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    NSDictionary *gepuDict = self.songsArray[indexPath.section];
     __block NSArray *detailArray = [NSArray array];
    [gepuDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        detailArray = obj;
    }];
    cell.textLabel.text = detailArray[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *gepuDict = self.songsArray[section];
    __block NSString *headerTitle = nil;
    [gepuDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        headerTitle = key;
    }];
    return headerTitle;
    
}


- (void)didUpdateCollect
{
    self.songsArray = nil;
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XRShowGepuViewController *showVC = [[XRShowGepuViewController alloc]init];
    
    NSDictionary *gepuDict = self.songsArray[indexPath.section];
    __block NSString *headerTitle = nil;
    __block NSArray *detailArray = [NSArray array];
    [gepuDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        headerTitle = key;
        detailArray = obj;
    }];
    showVC.gepu = headerTitle;
    showVC.song = detailArray[indexPath.row];
    showVC.didCancelBlock = ^(){
        self.songsArray = nil;
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:showVC animated:YES];

}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didCollect" object:nil];
}

-(void)tabBarDidChange
{
    if (self.tabBarController.selectedIndex == 0) {
        self.webViewController = nil;
    }
}


@end
