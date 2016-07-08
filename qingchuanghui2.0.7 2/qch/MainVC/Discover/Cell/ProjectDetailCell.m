//
//  ProjectDetailCell.m
//  qch
//
//  Created by 苏宾 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectDetailCell.h"

@implementation ProjectDetailCell

- (void)awakeFromNib {
    // Initialization code
    _line.hidden=YES;
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
    self.content.text = [NSString stringWithFormat:@" %@",text];
    self.content.numberOfLines =0;
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.content sizeThatFits:CGSizeMake((self.content.frame.size.width)*SCREEN_WSCALE, MAXFLOAT)];
    
    self.content.frame = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.content.frame.size.width, size.height);
    //计算出自适应的高度
    frame.size.height = size.height+50;
    self.frame = frame;
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-3*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line];
}


@end
