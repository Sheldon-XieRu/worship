//
//  XRDownloadCell.m
//  诗歌本恩泉
//
//  Created by Ru on 17/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRDownloadCell.h"
#import "GBKUIButtonProgressView.h"
#import "XRDownloadManager.h"
#import "gepu.h"
#import <SVProgressHUD.h>
#import <SSZipArchive.h>

@interface XRDownloadCell()<XRDownloadManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet GBKUIButtonProgressView *downloadButton;

@property (weak, nonatomic) IBOutlet UILabel *gepuNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *gepuImageView;


@property (nonatomic,assign,getter=isDownloading) BOOL downloading;


@property (nonatomic,assign,getter=isDownloaded) BOOL  downloaded;

// ** 下载业务类  */
@property (nonatomic,strong) XRDownloadManager *manager;


@property (nonatomic,strong) NSArray *gepuList;
@end

@implementation XRDownloadCell


-(XRDownloadManager *)manager
{
    if (_manager == nil) {
        _manager = [[XRDownloadManager alloc]init];
        _manager.delegate = self;
    }
    return _manager;
}



- (void)awakeFromNib {
    [super awakeFromNib];

    self.downloadButton.initialTitle = @"下载";
    self.downloadButton.completeTitle = @"删除";
    [self.downloadButton addTarget:self action:@selector(downloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
   [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
}


-(void)setGepu:(gepu *)gepu
{
    _gepu = gepu;
    self.gepuNameLabel.text = gepu.name;
    
    //如果已下载 设置
    if ([[NSUserDefaults standardUserDefaults]boolForKey:self.gepu.name]) {
        [self.downloadButton completeProgressing];
        self.downloaded = YES;
        self.downloading = NO;
    }else{
        [self.downloadButton reset];
        self.downloaded = NO;
    }

    self.gepuImageView.image = [UIImage imageNamed:gepu.image];


}


-(void)downloadButtonPressed:(id)sender {

    if(!self.downloading && !self.downloaded) {
        [self.downloadButton startProgressing];

        [self downloadItem];
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在下载《%@》",self.gepu.name]];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

        
    } else if(self.isDownloaded) {
        [self deleteItem];

    } else {
        [self cancelDownloadingItem];
        [self.downloadButton setProgress:0 animated:NO];
        [self.downloadButton reset];
        

    }
}


- (void)downloadItem
{

    [self.manager downloadWithUrl:self.gepu.url fileName:self.gepu.name];
   
   
}

- (void)deleteItem
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"确定删除《%@》？",self.gepu.name] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    

}


- (void)cancelDownloadingItem
{
    
}


-(void)downloadManagerDidUpdateProgress:(CGFloat)progress
{
    

    [self.downloadButton setProgress:progress animated:YES];
  
   
    if (progress == 1.0) {
    
        [SVProgressHUD dismiss];
        [self.downloadButton completeProgressing];
        
        //保存下载状态
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:self.gepu.name];
        
        self.downloaded = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }


}


//间隙控制

-(void)setFrame:(CGRect)frame
{

//    frame.origin.y += 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 10;
    [super setFrame:frame];
}



- (NSArray *)gepuList
{
    if (_gepuList==nil) {
        _gepuList = [gepu gepuList];
    }
    return _gepuList;
}

- (void)downloadManagerDidCompleteDownloadWithOriginal:(NSString *)originalPath FilefolderPath:(NSString *)filefolderPath
{
 
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showSuccessWithStatus:@"下载完成！"];
    
    NSString *destination = [originalPath stringByDeletingLastPathComponent];
    destination = [destination stringByAppendingPathComponent:self.gepu.name];
    [SSZipArchive unzipFileAtPath:originalPath toDestination:destination progressHandler:nil completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        
       [[NSFileManager defaultManager]removeItemAtPath:path error:nil];

        
    }];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            NSString *folderPath = [cachePath stringByAppendingPathComponent:self.gepu.name];

            [[NSFileManager defaultManager]removeItemAtPath:folderPath error:nil];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:self.gepu.name];
            self.downloaded = NO;
            [self.downloadButton reset];
        
        //删除收藏的歌谱歌曲
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        path = [path stringByAppendingString:@"savedsongs.plist"];
        NSMutableArray *allArray = [NSMutableArray arrayWithContentsOfFile:path];
        [allArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj[self.gepu.name]) {
                [allArray removeObject:obj];
            }
        }];
        [allArray writeToFile:path atomically:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"gepuDidDelete" object:nil];
        });
        
        
    }
}
@end
