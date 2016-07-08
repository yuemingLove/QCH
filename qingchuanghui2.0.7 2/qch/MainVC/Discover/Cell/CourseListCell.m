//
//  CourseListCell.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CourseListCell.h"
#import "DateFormatter.h"

@implementation CourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateFrame:(NSDictionary*)dict{

    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Course_Pic"]];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
    
//    NSString *group=[dict objectForKey:@"t_Course_Group"];
//    
//    if ([self isBlankString:group]) {//系列
//        [_signImageView setImage:[UIImage imageNamed:@""]];
//    } else {
//        NSString *price=[dict objectForKey:@"t_Course_Pic"];
//        if ([price isEqualToString:@"0.00"]) {//公益
//            [_signImageView setImage:[UIImage imageNamed:@""]];
//        } else {
//            [_signImageView setImage:[UIImage imageNamed:@""]];
//        }
//    }
//    
    _titleLabel.text=[dict objectForKey:@"t_Course_Title"];
    _longTimeLabel.text=[dict objectForKey:@"t_Course_Times"];
    _scanCountLabel.text=[dict objectForKey:@"t_Course_Counts"];
    NSString *date=[dict objectForKey:@"t_Add_Date"];
    NSDate *time=[DateFormatter stringToDateCustom:date formatString:def_YearMonthDayHourMinuteSec_DF];
    NSString *dateStr=[DateFormatter dateToStringCustom:time formatString:def_YearMonthDay_DF];
    _dateLabel.text=dateStr;
    
    NSMutableArray *itemArray=(NSMutableArray*)[dict objectForKey:@"Tips"];
    CGFloat width=(SCREEN_WIDTH-100)/4;
    for (int i=0; i<[itemArray count]; i++) {
        NSDictionary *dict =[itemArray objectAtIndex:i];
        
        NSString *tipName=[dict objectForKey:@"TipName"];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+(width+10)*i, _headImageView.bottom+10, width, 20);
        [button setTitle:tipName forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        
        CGFloat red = ( CGFloat ) random () / ( CGFloat ) RAND_MAX ;
        
        CGFloat green = ( CGFloat ) random () / ( CGFloat ) RAND_MAX ;
        
        CGFloat blue = ( CGFloat ) random () / ( CGFloat ) RAND_MAX ;
        
        UIColor *themeColor=[UIColor colorWithRed :red green :green blue :blue alpha :1];
        
        [button setTitleColor:themeColor forState:UIControlStateNormal];

        button.layer.borderColor=themeColor.CGColor;
        button.layer.borderWidth=1;
        button.layer.cornerRadius=button.height/2;
        
        [self addSubview:button];
    }

}

- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
