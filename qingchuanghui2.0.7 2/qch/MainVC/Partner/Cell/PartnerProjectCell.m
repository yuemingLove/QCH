//
//  PartnerProjectCell.m
//  qch
//
//  Created by 青创汇 on 16/3/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PartnerProjectCell.h"

@implementation PartnerProjectCell
{
    UIImageView *DynamicImg;
    UILabel *DynamicLab;
    UILabel *BaseInformationLab;
    UILabel *DynamicInformationLab;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)_initView{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,5*PMBWIDTH, ScreenWidth, 35*PMBWIDTH)];
    view.backgroundColor = TSEColor(243, 243, 243);
    [self addSubview:view];
    
    DynamicLab = [[UILabel alloc]initWithFrame:CGRectMake(12*PMBWIDTH, 11*PMBWIDTH, 100*PMBWIDTH, 14*PMBWIDTH)];
    DynamicLab.text = @"Ta的项目";
    DynamicLab.textColor = TSEColor(102, 102, 102);
    DynamicLab.font = Font(14);
    [view addSubview:DynamicLab];
    
    DynamicImg = [[UIImageView alloc]initWithFrame:CGRectMake(DynamicLab.left, view.bottom+15*PMBWIDTH, 90*PMBWIDTH,72*PMBWIDTH)];
    [self addSubview:DynamicImg];
    
    BaseInformationLab = [[UILabel alloc]initWithFrame:CGRectMake(DynamicImg.right+10*PMBWIDTH, DynamicImg.top+15*PMBWIDTH, 160*PMBWIDTH, 14*PMBWIDTH)];
    
    BaseInformationLab.textAlignment = NSTextAlignmentLeft;
    BaseInformationLab.font = Font(14);
    [self addSubview:BaseInformationLab];
    
    _MoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _MoreBtn.frame = CGRectMake(ScreenWidth-60*PMBWIDTH, BaseInformationLab.bottom-5*PMBWIDTH, 50*PMBWIDTH, 30*PMBWIDTH);
    [_MoreBtn setImage:[UIImage imageNamed:@"jinru_btn"] forState:UIControlStateNormal];
    [self addSubview:_MoreBtn];
    
    DynamicInformationLab = [[UILabel alloc]initWithFrame:CGRectMake(BaseInformationLab.left, BaseInformationLab.bottom+15*PMBWIDTH, BaseInformationLab.width, 15*PMBWIDTH)];
    DynamicInformationLab.textColor = TSEColor(180, 180, 180);
    DynamicInformationLab.font = Font(15);
    [self addSubview:DynamicInformationLab];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *array = _model.userProject;
    if (array.count>0) {
        UserProject *project = array[0];
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,project.tProjectConverPic];
            [DynamicImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_3"]];
        BaseInformationLab.text = project.projectName;
        DynamicInformationLab.text = project.tProjectOneWord;
    }
}    
@end
