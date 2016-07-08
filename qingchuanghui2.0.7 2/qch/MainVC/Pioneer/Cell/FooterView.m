//
//  FooterView.m
//  qch
//
//  Created by 青创汇 on 16/1/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

-(void)_initView {
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.frame = CGRectMake(5*PMBWIDTH, 15*PMBWIDTH, 80*PMBWIDTH, 20*PMBWIDTH);
    _locationBtn.layer.cornerRadius = _locationBtn.height/2;
    _locationBtn.layer.masksToBounds = YES;
    _locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _locationBtn.layer.borderWidth = 1;
    [_locationBtn setImage:[UIImage imageNamed:@"dongtai_dd1_btn"] forState:UIControlStateNormal];
    [_locationBtn setTitle:@"当前位置" forState:UIControlStateNormal];
    _locationBtn.titleLabel.font = Font(15);
    [_locationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:_locationBtn];


}

@end
