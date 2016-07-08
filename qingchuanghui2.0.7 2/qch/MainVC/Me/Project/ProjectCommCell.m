//
//  ProjectCommCell.m
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectCommCell.h"

@implementation ProjectCommCell

- (void)awakeFromNib {
    // Initialization code
    
    _bgView.layer.masksToBounds=YES;
    _bgView.layer.cornerRadius=3;
    
    _pImageView.layer.masksToBounds=YES;
    _pImageView.layer.cornerRadius=_pImageView.height/2;
    
    _comImageView.layer.masksToBounds=YES;
    _comImageView.layer.cornerRadius=_comImageView.height/2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
