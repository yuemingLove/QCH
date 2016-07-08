//
//  TutorDetailCell.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TutorDetailCell.h"

@implementation TutorDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    self.contentLabel.text = text;
    self.contentLabel.numberOfLines =0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake((self.contentLabel.frame.size.width)*SCREEN_WSCALE, MAXFLOAT)];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
    
    
    frame.size.height=size.height+40;
    
    self.frame = frame;
    
}

@end
