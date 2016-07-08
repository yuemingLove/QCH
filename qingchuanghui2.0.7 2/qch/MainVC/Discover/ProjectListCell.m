//
//  ProjectListCell.m
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectListCell.h"

@implementation ProjectListCell

- (void)awakeFromNib {
    // Initialization code
    _pImageView.layer.masksToBounds=YES;
    _pImageView.layer.cornerRadius=_pImageView.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateFrame:(NSDictionary*)dict{

    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Invest_Pic"]];
    [_pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    NSString *text = [dict objectForKey:@"t_Invest_Project"];
    if (text.length>10) {
        text = [text substringToIndex:10];
    }
    _nameLabel.text=[NSString stringWithFormat:@"%@",text];
    NSDictionary *InvestPhase=[dict objectForKey:@"InvestPhase"][0];
    _statusLabel.text=[InvestPhase objectForKey:@"InvestPhaseName"];
//    NSString *date=[dict objectForKey:@"t_Invest_Date"];
//    date=[date stringByReplacingOccurrencesOfString:@"/" withString:@"."];
//    date=[date substringToIndex:6];
    NSDate *date = [DateFormatter stringToDateCustom:[dict objectForKey:@"t_Invest_Date"] formatString:def_YearMonthDayHourMinuteSec_];
    NSString *Date = [DateFormatter dateToStringCustom:date formatString:def_YearMobth];
    _timeLabel.text=Date;
    
}

@end
