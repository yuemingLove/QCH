//
//  MyDetailFirstCell.m
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyDetailThirdCell.h"

@implementation MyDetailThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickButtonAction:(UIButton *)sender {
    Liu_DBG(@"%ld", sender.tag);
    if ([self.delegate respondsToSelector:@selector(clickTheThirdButton:)]) {
        [self.delegate clickTheThirdButton:sender.tag];
    }
}

@end
