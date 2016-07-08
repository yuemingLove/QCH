//
//  CarePersonCell.m
//  qch
//
//  Created by 青创汇 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CarePersonCell.h"

@implementation CarePersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}
- (void)_initView{
    
    _IconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBHEIGHT, 30*PMBWIDTH, 30*PMBHEIGHT)];
    _IconImage.layer.cornerRadius = _IconImage.height/2;
    _IconImage.layer.masksToBounds = YES;
    [self addSubview:_IconImage];
    
    
    _NameLab = [[UILabel alloc]initWithFrame:CGRectMake(_IconImage.right+10*PMBWIDTH, _IconImage.top, 180*PMBWIDTH, 14*PMBHEIGHT)];
    _NameLab.textColor = [UIColor blackColor];
    _NameLab.font = Font(14);
    [self addSubview:_NameLab];
    
    UIImageView *biaoqianimg = [[UIImageView alloc]initWithFrame:CGRectMake(_NameLab.left, _NameLab.bottom+5*PMBWIDTH, 15*PMBWIDTH, 15*PMBWIDTH)];
    biaoqianimg.image = [UIImage imageNamed:@"biaoqian"];
    [self addSubview:biaoqianimg];
    
    
    _IdentityLab = [[UILabel alloc]initWithFrame:CGRectMake(biaoqianimg.right+2*PMBWIDTH, biaoqianimg.top, 100*PMBWIDTH, 14*PMBWIDTH)];
    _IdentityLab.textColor = TSEColor(132,132, 132);
    _IdentityLab.font = Font(14);
    [self addSubview:_IdentityLab];
    
    
//    _CareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _CareBtn.frame = CGRectMake(ScreenWidth-80*PMBWIDTH, _NameLab.top-3*PMBHEIGHT, 60*PMBWIDTH, 30*PMBHEIGHT);
//    _CareBtn.tag = self.tag;
//    [_CareBtn addTarget:self action:@selector(care:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_CareBtn];
    
    
}
- (void)care:(UIButton*)sender
{
    if ([self.CareDelegate respondsToSelector:@selector(careClicked:index:)]) {
        [self.CareDelegate careClicked:self index:[sender tag]];
    }
}

@end
