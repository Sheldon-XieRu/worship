//
//  XRPopTableViewCell.m
//  诗歌本恩泉
//
//  Created by Ru on 16/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "XRPopTableViewCell.h"

@interface XRPopTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *gepuNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gepuIndicator;

@end
@implementation XRPopTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
//     self.gepuIndicator.hidden = !selected;
}

-(void)setGepuName:(NSString *)gepuName
{
    _gepuName = gepuName;
    NSString *selectedGepu = [[NSUserDefaults standardUserDefaults]stringForKey:@"selectedGepu"];
    if ([gepuName isEqualToString:selectedGepu]) {
        self.gepuIndicator.hidden = NO;
    }else{
        self.gepuIndicator.hidden = YES;
    }

    self.gepuNameLabel.text = gepuName;

}

@end
