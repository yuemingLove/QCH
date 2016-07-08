//
//  MessageCell.m
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //文本赋值
    self.contentLabel.text = text;
    self.contentLabel.numberOfLines =0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
    
    //计算出自适应的高度
    frame.size.height = size.height/SCREEN_WSCALE+50;
    self.frame = frame;
}

@end
