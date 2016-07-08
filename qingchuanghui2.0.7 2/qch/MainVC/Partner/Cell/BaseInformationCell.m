//
//  BaseInformationCell.m
//  qch
//
//  Created by 青创汇 on 16/2/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "BaseInformationCell.h"

@implementation BaseInformationCell{
    UILabel *CityLab;
    UILabel *FocusLab;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)_initView{
    self.backgroundColor = [UIColor whiteColor];
    CityLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*SCREEN_WSCALE,ScreenWidth/3, 13*SCREEN_WSCALE)];
    CityLab.textAlignment = NSTextAlignmentCenter;
    CityLab.textColor = TSEColor(153, 153, 153);
    CityLab.font = Font(13);
    [self addSubview:CityLab];
    
    UILabel *citylab = [[UILabel alloc]initWithFrame:CGRectMake(0, CityLab.bottom+5*SCREEN_WSCALE, CityLab.width, CityLab.height)];
    citylab.text = @"城市";
    citylab.textAlignment = NSTextAlignmentCenter;
    citylab.font = Font(13);
    citylab.textColor = TSEColor(209, 209, 209);
    [self addSubview:citylab];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/3,15*SCREEN_WSCALE, 1*PMBWIDTH, 25*SCREEN_WSCALE)];
    line1.backgroundColor = TSEColor(245,245,245);
    [self addSubview:line1];
    
    FocusLab = [[UILabel alloc]initWithFrame:CGRectMake(line1.right, CityLab.top,CityLab.width, CityLab.height)];
    FocusLab.textColor = TSEColor(153, 153, 153);
    FocusLab.textAlignment = NSTextAlignmentCenter;
    FocusLab.font = Font(13);
    [self addSubview:FocusLab];
    
    UILabel *focuslab = [[UILabel alloc]initWithFrame:CGRectMake(FocusLab.left,FocusLab.bottom+5*SCREEN_WSCALE, FocusLab.width, FocusLab.height)];
    focuslab.text = @"关注";
    focuslab.textAlignment = NSTextAlignmentCenter;
    focuslab.font = Font(13);
    focuslab.textColor = TSEColor(209, 209, 209);
    [self addSubview:focuslab];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(FocusLab.right, line1.top, 1*PMBWIDTH, 25*SCREEN_WSCALE)];
    line2.backgroundColor = TSEColor(245, 245, 245);
    [self addSubview:line2];
    
    _FansLab = [[UILabel alloc]initWithFrame:CGRectMake(line2.right, FocusLab.top,FocusLab.width, FocusLab.height)];
    _FansLab.textAlignment = NSTextAlignmentCenter;
    _FansLab.textColor = TSEColor(153, 153, 153);
    _FansLab.font = Font(13);
    [self addSubview:_FansLab];
    
    UILabel *fanslab = [[UILabel alloc]initWithFrame:CGRectMake(_FansLab.left, _FansLab.bottom+5*SCREEN_WSCALE, _FansLab.width, _FansLab.height)];
    fanslab.text = @"粉丝";
    fanslab.textAlignment = NSTextAlignmentCenter;
    fanslab.font = Font(13);
    fanslab.textColor = TSEColor(209, 209, 209);
    [self addSubview:fanslab];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if ([_model.tUserCity isEqualToString:@""]) {
        CityLab.text = @"暂无";
    }else{
    CityLab.text = _model.tUserCity;
    }
    //关注
    FocusLab.text = _model.pCount;
    
}
@end
