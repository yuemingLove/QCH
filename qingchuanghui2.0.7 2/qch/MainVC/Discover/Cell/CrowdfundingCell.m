//
//  CourseCell.m
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CrowdfundingCell.h"

@implementation CrowdfundingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    _money.textColor = [UIColor themeOrangeColor];
    _Information.numberOfLines = 0;
    [_Supportbtn setTitleColor:[UIColor themeOrangeColor] forState:UIControlStateNormal];
    _Supportbtn.layer.cornerRadius = _Supportbtn.height/2;
    _Supportbtn.layer.borderWidth = 1.0f;
    _Supportbtn.layer.borderColor = TSEColor(240, 140, 0).CGColor;
    
    
}

- (void)updataframe:(NSDictionary *)dict
{
    
    _Information.text = [dict objectForKey:@"T_FundCourse_Title"];
    _money.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"hadMoney"]];
    NSDate *date = [DateFormatter stringToDateCustom:[dict objectForKey:@"T_FundCourse_Date"] formatString: def_YearMonthDay_DF];
    NSString *time = [DateFormatter dateToStringCustom:date formatString:def_MonthDay_DF];
    _Time.text = [NSString stringWithFormat:@"%@ %@",time,[dict objectForKey:@"T_FundCourse_sTime"]];
    _count.text = [dict objectForKey:@"count"];
    float progValue = [(NSNumber*)[dict objectForKey:@"hadMoney"]floatValue]/[(NSNumber*)[dict objectForKey:@"T_FundCourse_Money"]floatValue];
    _Support.text = [dict objectForKey:@"percent"];
    _Progress.progress = progValue;
    
}
@end
