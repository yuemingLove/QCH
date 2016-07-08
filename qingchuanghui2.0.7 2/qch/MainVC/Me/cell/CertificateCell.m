//
//  CertificateCell.m
//  qch
//
//  Created by 青创汇 on 16/4/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CertificateCell.h"

@implementation CertificateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor=[UIColor themeGrayColor];
    
    _bgkView.layer.borderColor=[UIColor colorWithRed:(2.0f / 255.0f) green:(153.0f / 255.0f) blue:(232.0f / 255.0f) alpha:1.0f].CGColor;
    
    _bgkView.layer.borderWidth=1.0f;
    
}



@end
