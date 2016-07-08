//
//  MyAppointCell.m
//  qch
//
//  Created by 苏宾 on 16/3/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyAppointCell.h"

@implementation MyAppointCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateFrame:(NSDictionary*)dict{
    
    NSInteger state=[(NSNumber*)[dict objectForKey:@"t_State"]integerValue];
    if (state==0) {//未到
        [_sImageView setImage:[UIImage imageNamed:@"weidao"]];
    }else if (state==1){//已到
        [_sImageView setImage:[UIImage imageNamed:@"yidao"]];
    }else if (state==2){//已离开
        [_sImageView setImage:[UIImage imageNamed:@"yilikai"]];
    }else if (state==3){//取消
        [_sImageView setImage:[UIImage imageNamed:@"quxiao"]];
    }
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Place_Pic"]];
    [_rImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_3"]];
    
    _roomNameLabel.text=[dict objectForKey:@"t_Place_Name"];
    _numLabel.text=[dict objectForKey:@"t_Ordered_NO"];
    _addressLabel.text=[dict objectForKey:@"t_Place_StyleName"];
    _priceLabel.text=[NSString stringWithFormat:@"%@元",[dict objectForKey:@"t_Place_Money"]];
    _cityLabel.text=[dict objectForKey:@"t_Place_CityName"];
    NSString *date=[dict objectForKey:@"t_Order_Date"];
    date=[date stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    date=[date substringFromIndex:5];
    date=[date substringToIndex:4];
    _timeLabel.text=[NSString stringWithFormat:@"%@ %@:00-%@:00",date,[dict objectForKey:@"t_PlaceOder_sTime"],[dict objectForKey:@"t_PlaceOder_eTime"]];
    
}

@end
