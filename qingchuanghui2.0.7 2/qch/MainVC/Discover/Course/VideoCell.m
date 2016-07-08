//
//  VideoCell.m
//  WMVideoPlayer
//
//  Created by zhengwenming on 16/1/17.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"

@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateFrame:(NSDictionary *)dict
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.text = [dict objectForKey:@"t_Live_Title"];
    self.descriptionLabel.text = [dict objectForKey:@"t_Live_Instruction"];
    [self.backgroundIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Live_Pic"]]] placeholderImage:[UIImage imageNamed:@"logo1"]];
    self.countLabel.text = [dict objectForKey:@"t_Live_Counts"];
    self.timeDurationLabel.text = [dict objectForKey:@"t_Live_Times"];


    
}
//-(void)setModel:(VideoModel *)model{
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.titleLabel.text = model.title;
//    self.descriptionLabel.text = model.descriptionDe;
//    [self.backgroundIV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"logo"]];
//    self.countLabel.text = [NSString stringWithFormat:@"%ld.%ld万",model.playCount/10000,model.playCount/1000-model.playCount/10000];
//    self.timeDurationLabel.text = [model.ptime substringWithRange:NSMakeRange(12, 4)];
//
//}

@end
