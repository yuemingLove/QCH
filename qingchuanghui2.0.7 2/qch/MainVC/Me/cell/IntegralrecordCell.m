//
//  IntegralrecordCell.m
//  qch
//
//  Created by 青创汇 on 16/6/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "IntegralrecordCell.h"

@implementation IntegralrecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updata:(NSDictionary *)dict
{
    _Time.text = [dict objectForKey:@"t_AddDate"];
    _Integarl.text = [NSString stringWithFormat:@"剩余积分:%@",[dict objectForKey:@"t_UserIntegral_Reward"]];
    _Remark.text = [dict objectForKey:@"t_Remark"];
    if ([self isBlankString:[dict objectForKey:@"t_UserIntegral_ReduceReward"]]||[[dict objectForKey:@"t_UserIntegral_ReduceReward"]isEqualToString:@"0"]) {
        _Record.text = [NSString stringWithFormat:@"+ %@",[dict objectForKey:@"t_UserIntergral_AddReward"]];
        _BackImg.image = [UIImage imageNamed:@"my_huodejifen"];
    }else if ([self isBlankString:[dict objectForKey:@"t_UserIntergral_AddReward"]]||[[dict objectForKey:@"t_UserIntergral_AddReward"]isEqualToString:@"0"]){
        _Record.text = [NSString stringWithFormat:@"- %@",[dict objectForKey:@"t_UserIntegral_ReduceReward"]];
        _BackImg.image = [UIImage imageNamed:@"my_xiaofeijifen"];
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
