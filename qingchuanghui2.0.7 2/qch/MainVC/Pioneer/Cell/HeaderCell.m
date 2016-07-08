//
//  HeaderCell.m
//  qch
//
//  Created by 苏宾 on 16/1/30.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (void)awakeFromNib {
    _headImageView.layer.masksToBounds=YES;
    _headImageView.layer.cornerRadius=_headImageView.height/2;
}

@end
