//
//  MyDetailFirstCell.m
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyDetailFirstCell.h"

@implementation MyDetailFirstCell

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
    if ([self.delegate respondsToSelector:@selector(clickTheFirstButton:)]) {
        [self.delegate clickTheFirstButton:sender.tag];
    }
}

@end
