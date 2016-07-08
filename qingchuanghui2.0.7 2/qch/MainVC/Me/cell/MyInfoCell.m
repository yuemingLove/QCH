//
//  MyInfoCell.m
//  qch
//
//  Created by 苏宾 on 16/2/29.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

- (void)awakeFromNib {
    _pImageView.layer.masksToBounds=YES;
    _pImageView.layer.cornerRadius=_pImageView.height/2;
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(_fristBtn.right+2.5, _fristBtn.top-10, 1, 20)];
    line.backgroundColor=[UIColor themeGrayColor];
    [self addSubview:line];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(_secordBtn.right+2.5, _fristBtn.top-10, 1, 20)];
    line2.backgroundColor=[UIColor themeGrayColor];
    [self addSubview:line2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(IBAction)clinkList:(UIButton*)sender{

    if ([self.infoDelegate respondsToSelector:@selector(clinkListView:index:)]) {
        [self.infoDelegate clinkListView:self index:[sender tag]];
    }
}

-(IBAction)clinkBigImage:(UIButton*)sender{

    if ([self.infoDelegate respondsToSelector:@selector(clinkBigImage:)]) {
        [self.infoDelegate clickBigImage:self];
    }
}

@end
