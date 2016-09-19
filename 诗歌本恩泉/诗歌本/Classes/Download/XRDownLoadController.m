//
//  XRDownLoadController.m
//  诗歌本恩泉
//
//  Created by Ru on 17/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRDownLoadController.h"
#import "XRDownloadCell.h"
#import "XRDownloadManager.h"
#import "gepu.h"
#import "XRDownloadManager.h"


@interface XRDownLoadController ()

// ** <#注释#>  */
@property (nonatomic,strong) XRDownloadManager *downloadManager;

// ** 歌谱数组  */
@property (nonatomic,strong) NSMutableArray *gepuList;

// ** 正在下载的cell序号 */
@property (nonatomic,assign) NSInteger downloadingIndex;

@end

@implementation XRDownLoadController


static NSString * const cellID = @"downloadCell";

-(NSMutableArray *)gepuList
{
    if (_gepuList == nil) {
        _gepuList = (NSMutableArray *)[gepu gepuList];
    }
    return _gepuList;
}


- (void)viewDidLoad {
    

    
    [super viewDidLoad];
    
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XRDownloadCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.showsHorizontalScrollIndicator = NO;

    self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 44, 0);
    self.tableView.rowHeight = 180;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    
    



    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    headerLabel.numberOfLines = 0;
    headerLabel.text = @"  文件较大，请耐心等待😊 下载完成后便可在首页切换";
    headerLabel.font = [UIFont systemFontOfSize:13];
    headerLabel.textColor = [UIColor darkGrayColor];
     [headerLabel sizeToFit];

    self.tableView.tableHeaderView = headerLabel;
    
    

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.gepuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   XRDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    cell.gepu  =  self.gepuList[indexPath.row];

    return cell;
}





@end
