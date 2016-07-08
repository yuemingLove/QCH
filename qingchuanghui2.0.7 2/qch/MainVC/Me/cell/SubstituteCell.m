//
//  SubstituteCell.m
//  qch
//
//  Created by W.兵 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SubstituteCell.h"

@implementation SubstituteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor themeGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateData:(NSDictionary *)dict
{
    _titleLabel.text = [dict objectForKey:@"T_Remark"];
    _dateLabel.text = [NSString stringWithFormat:@"有效期至%@",[dict objectForKey:@"T_sDate"]];
    if ([[dict objectForKey:@"isvalid"]isEqualToString:@"0"]) {
        _bkgImageView.image = [UIImage imageNamed:@"tiyanquan"];
        _endLineImageView.hidden= YES;
    }else if ([[dict objectForKey:@"isvalid"]isEqualToString:@"1"]){
        _bkgImageView.image = [UIImage imageNamed:@"tiyanquan guoqi"];
        _endLineImageView.hidden = NO;
    }
    
}
@end
