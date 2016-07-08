//
//  InvestCell.m
//  qch
//
//  Created by 青创汇 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "Invest2Cell.h"

@implementation Invest2Cell
{
    UIImageView *LOGOImg;
    UILabel *NameLab;
    UILabel *StageLab;
    UILabel *DateLab;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView{
    LOGOImg = [[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, 60*PMBWIDTH, 60*PMBWIDTH)];
    LOGOImg.layer.cornerRadius = LOGOImg.height/2;
    LOGOImg.layer.masksToBounds = YES;
    [self addSubview:LOGOImg];
    
    NameLab = [[UILabel alloc]initWithFrame:CGRectMake(LOGOImg.right+15*PMBWIDTH, LOGOImg.top+23*PMBWIDTH, 70*PMBWIDTH, 14*PMBWIDTH)];
    NameLab.textColor = [UIColor blackColor];
    NameLab.font = Font(14);
    NameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:NameLab];
    
    DateLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-5*PMBWIDTH-50*PMBWIDTH, NameLab.top+1*PMBWIDTH, 50*PMBWIDTH, 12*PMBWIDTH)];
    DateLab.textColor = TSEColor(202, 202, 202);
    DateLab.font = Font(12);
    DateLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:DateLab];
    
    StageLab = [[UILabel alloc]initWithFrame:CGRectMake(NameLab.right+15*PMBWIDTH, DateLab.top, DateLab.left-15*PMBWIDTH-NameLab.right-15*PMBWIDTH, 12*PMBWIDTH)];
    StageLab.textColor = TSEColor(202, 202, 202);
    StageLab.font = Font(12);
    StageLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:StageLab];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_Dict objectForKey:@"t_Invest_Pic"]];
    [LOGOImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    NameLab.text = [_Dict objectForKey:@"t_Invest_Project"];
    NSDate *date = [DateFormatter stringToDateCustom:[_Dict objectForKey:@"t_Invest_Date"] formatString:def_YearMonthDayHourMinuteSec_];
    NSString *Date = [DateFormatter dateToStringCustom:date formatString:def_YearMobth];
    DateLab.text = Date;
    NSString *StageString = @"";
    for (int i=0; i<[[_Dict objectForKey:@"InvestPhase"] count]; i++) {
        NSDictionary *dict = [[_Dict objectForKey:@"InvestPhase"] objectAtIndex:i];
        NSString *stage =[dict objectForKey:@"InvestPhaseName"];
        if ([StageString isEqualToString:@""]) {
            StageString = stage;
        }else{
            StageString = [StageString stringByAppendingString:[NSString stringWithFormat:@"  %@",stage]];
        }
    }
    StageLab.text = StageString;
}


@end
