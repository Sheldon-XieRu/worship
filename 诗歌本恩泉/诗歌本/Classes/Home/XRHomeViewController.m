//
//  XRHomeViewController.m
//  诗歌本
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRHomeViewController.h"
#import "XRTitleButton.h"
#import "XRPopTableViewController.h"
#import "gepu.h"
#import "XRShowGepuViewController.h"
#import "XRColletionViewController.h"
#import <Masonry.h>
@interface XRHomeViewController ()<UISearchResultsUpdating,XRPopTableViewControllerDelegate>

//** 选中的歌谱 */
@property (nonatomic,copy) NSString *selectedGepu;

// ** 选择诗歌本的window  */
@property (nonatomic,strong) UIWindow *popWindow;

// ** 歌谱名字数组  */
@property (nonatomic,strong) NSArray *songList;

// ** 搜索·  */
@property (nonatomic,strong) UISearchController *searchController;

// ** 搜索结果  */
@property (nonatomic,strong) NSMutableArray *searchResults;


//** 最大分组
@property (nonatomic,assign) NSInteger maxSection;

// ** 上次选中tabbar index */
@property (nonatomic,assign) NSInteger lastIndex;


@end

@implementation XRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self setupNavBar];

    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.tintColor = [UIColor darkGrayColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarDidChange) name:@"tabBarDidChange" object:nil];
    
    self.tableView.alwaysBounceVertical = YES;


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.webViewController) {
    UIBarButtonItem *youkuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Film-100"] style:UIBarButtonItemStylePlain target:self action:@selector(searchYouku)];
       UIBarButtonItem *serchitem= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClick)];
        
        self.navigationItem.rightBarButtonItems = @[youkuItem,serchitem];
    }
}

- (NSArray *)songList
{
    if (_songList == nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:self.selectedGepu ofType:@"plist"];
        _songList = [NSArray arrayWithContentsOfFile:path];
        
    }
    return _songList;

}

-(NSString *)selectedGepu
{
    if (_selectedGepu == nil) {
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"selectedGepu"]) {
            _selectedGepu = [[NSUserDefaults standardUserDefaults]stringForKey:@"selectedGepu"];
        }else{
            _selectedGepu = @"恩泉佳音";
            [[NSUserDefaults standardUserDefaults]setObject:@"恩泉佳音" forKey:@"selectedGepu"];
        }
    }
    return _selectedGepu;
}
-(NSArray *)searchResults
{
    if (_searchResults == nil) {
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}

-(UISearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.dimsBackgroundDuringPresentation = true;
        _searchController.obscuresBackgroundDuringPresentation = false;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.placeholder = @"请输入要查找的歌名或序号";
        
        //        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    }
    return _searchController;
}
- (void)setupNavBar
{
    XRTitleButton *titleButton = [XRTitleButton buttonWithType:UIButtonTypeCustom];
    
    [titleButton setTitle:[[NSUserDefaults standardUserDefaults]stringForKey:@"selectedGepu"] forState:UIControlStateNormal];
    //第一次启动还没有设置
    if (titleButton.titleLabel.text == nil) {
        [titleButton setTitle:@"恩泉佳音" forState:UIControlStateNormal];
    }
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleButton addTarget:self action:@selector(showPop:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleButton sizeToFit];
    
    
    self.navigationItem.titleView = titleButton;
    
    
    
    XRPopTableViewController *popVC = [[XRPopTableViewController alloc]init];
    popVC.delegate = self;
    
    UIWindow *popWindow = [[UIWindow alloc]init];
    self.popWindow = popWindow;
    


    
    CGFloat windowW = 200;
    CGFloat windowH = 200;
    CGFloat windowX = ([UIScreen mainScreen].bounds.size.width - windowW) * 0.5;
    CGFloat windowY = 64 + 5;
    popWindow.frame =  CGRectMake(windowX, windowY, windowW, windowH);
    popWindow.backgroundColor = [UIColor clearColor];
    popWindow.rootViewController = popVC;

    
    popWindow.windowLevel = UIWindowLevelStatusBar;
    
    
    //搜索图标
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClick)];
    
    
    
}


- (void)searchButtonClick
{
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchController.searchBar becomeFirstResponder];
    });

}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active == YES) {
  
        return 1;
        
    }else{
         return  (self.maxSection = self.songList.count / 50 + 1);
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.searchController.active == YES) {
        return self.searchResults.count;
    }else{
        if (section == self.maxSection - 1) {
            return self.songList.count % 50;
        }else{
            return 50;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.searchController.active == YES) {
        cell.textLabel.text = self.searchResults[indexPath.row];
    }else{
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
//        NSInteger total = self.songList.count;
        
        cell.textLabel.text = self.songList[section * 50 + row];
    }
    return cell;
    
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.maxSection; i++) {
        [array addObject:[NSString stringWithFormat:@"%zd",i * 50]];
    }
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    
    return array;
}


- (void)showPop:(XRTitleButton *)titleButton
{
    titleButton.imageView.transform = CGAffineTransformRotate(titleButton.imageView.transform, M_PI);
    
    
    
    XRPopTableViewController *tableVC =(XRPopTableViewController *) self.popWindow.rootViewController;
    
    NSMutableArray *tempDownloadedlist = [NSMutableArray array];
    //默认歌谱
    gepu *defaultGepu = [[gepu alloc]init];
    defaultGepu.name = @"恩泉佳音";
    [tempDownloadedlist addObject:defaultGepu];

    
    //寻找已经下载的歌谱
    for (gepu *gepuItem in [gepu gepuList]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:gepuItem.name]) {
            [tempDownloadedlist addObject:gepuItem];
        }
    }
    tableVC.downloadedList = tempDownloadedlist;
    
    //每次进来刷新
    [tableVC.tableView reloadData];
    
    

 
    
    self.popWindow.hidden = ! self.popWindow.hidden;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.popWindow.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.popWindow.hidden = YES;
    XRShowGepuViewController *showingVC = [[XRShowGepuViewController alloc]init];
    if (self.searchController.active == YES) {
        showingVC.song = self.searchResults[indexPath.row];
        self.searchController.active = NO;
    }else{
 
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
      
        
        showingVC.song = self.songList[section * 50 + row];
        
        
    }

    showingVC.gepu = self.selectedGepu;
    
//
    [self.navigationController pushViewController:showingVC animated:YES];
}

/**
 *  更新搜索结果
 
 */
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if ([searchController.searchBar.text isEqualToString: @""]) {
        self.searchResults = (NSMutableArray *)self.songList;
        [self.tableView reloadData];
        return;
    }
    
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",self.searchController.searchBar.text];
    
    self.searchResults = (NSMutableArray *)[self.songList filteredArrayUsingPredicate:predict];
    [self.tableView reloadData];
}


- (void)PopTableViewControllerDidSelected
{
    self.selectedGepu = nil;
    self.songList = nil;

    [self.tableView reloadData];
    XRTitleButton *titleButton =(XRTitleButton *)self.navigationItem.titleView;
    [titleButton setTitle:self.selectedGepu forState:UIControlStateNormal];
    [titleButton sizeToFit];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.popWindow.hidden = YES;
        }];
    });
}

- (void)searchYouku
{
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

- (void)tabBarDidChange
{
    self.popWindow.hidden = YES;
    if (self.lastIndex == self.tabBarController.selectedIndex) {
      
        [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
        
    }

    if (self.tabBarController.selectedIndex == 1) {
         self.webViewController = nil;
    }
    
    self.lastIndex = self.tabBarController.selectedIndex;
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"tabBarDidChange" object:nil];
}
@end
