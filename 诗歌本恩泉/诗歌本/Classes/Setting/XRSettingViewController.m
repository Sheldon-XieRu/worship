//
//  XRSettingViewController.m
//  诗歌本恩泉
//
//  Created by Ru on 26/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRSettingViewController.h"
#import "WXApi.h"
#import <SVProgressHUD.h>
#import "UIImage+Extension.h"
@interface XRSettingViewController ()
// ** 常亮开关 * /
@property (nonatomic,weak) UISwitch *alwasLightSwith;

// ** <#注释#> * /
@property (nonatomic,strong) UIButton *inviteButton;

@end

@implementation XRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"设置屏幕常亮";
        UISwitch *alwaysSwitch = [[UISwitch alloc]init];
        
        alwaysSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"alwaysLight"];
        
        self.alwasLightSwith = alwaysSwitch;
        [alwaysSwitch addTarget:self action:@selector(lightAlwaysOn:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = alwaysSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section ==1){
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"好评或反馈";
            return cell;

        
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"邀请小伙伴下载诗歌本";
            cell.imageView.image = [UIImage imageNamed:@"convenient_share_wx"];
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"分享诗歌本到朋友圈";
            cell.imageView.image = [UIImage imageNamed:@"convenient_share_pyq"];
            return cell;
    }
    
}
}
- (void)lightAlwaysOn:(UISwitch *)lightSwitch
{
    [[UIApplication sharedApplication]setIdleTimerDisabled:lightSwitch.on];
    [[NSUserDefaults standardUserDefaults]setBool:lightSwitch.on forKey:@"alwaysLight"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ji-du-tu-jing-bai-zan-mei/id1110726577?mt=8"]];
    }else if (indexPath.section == 2){
        if (indexPath.row ==0 | indexPath.row == 1) {
            
            WXMediaMessage *message = [[WXMediaMessage alloc]init];
            message.title = @"一起来敬拜主吧!";
            message.description = @"下载诗歌本，一起来敬拜赞美我们伟大的神";
            message.thumbData = UIImagePNGRepresentation([[UIImage imageNamed:@"message"] roundedImage]);
            
            WXWebpageObject *webObject = [WXWebpageObject object];
            webObject.webpageUrl = @"https://itunes.apple.com/cn/app/ji-du-tu-jing-bai-zan-mei/id1110726577?mt=8";
            message.mediaObject = webObject;
            
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.message = message;
            req.scene =  (int)indexPath.row;
            [WXApi sendReq:req];
        }
    }
}



@end
