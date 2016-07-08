//
//  ParntIntCell.m
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ParntIntCell.h"

@implementation ParntIntCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //文本赋值
    self.contentLabel.text = [NSString stringWithFormat:@" %@",text];
    self.contentLabel.numberOfLines =0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
    //计算出自适应的高度
    frame.size.height = size.height+20*SCREEN_WSCALE;
    self.frame = frame;
    
}


@end
