//
//  PersonDynamicCell.m
//
//
//  Created by 青创汇 on 16/2/17.
//
//

#import "PersonDynamicCell.h"

@implementation PersonDynamicCell{
    
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
    DynamicLab.text = @"Ta的动态";
    DynamicLab.textColor = TSEColor(102, 102, 102);
    DynamicLab.font = Font(14);
    [view addSubview:DynamicLab];
    
    DynamicImg = [[UIImageView alloc]initWithFrame:CGRectMake(DynamicLab.left, view.bottom+15*PMBWIDTH, 90*PMBWIDTH, 72*PMBWIDTH)];
    [self addSubview:DynamicImg];
    
    BaseInformationLab = [[UILabel alloc]initWithFrame:CGRectMake(DynamicImg.right+10*PMBWIDTH, DynamicImg.top+15*PMBWIDTH, 160*PMBWIDTH, 14*PMBWIDTH)];
    
    BaseInformationLab.textAlignment = NSTextAlignmentLeft;
    BaseInformationLab.font = Font(14);
    [self addSubview:BaseInformationLab];
    
    _SelctedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SelctedBtn.frame = CGRectMake(ScreenWidth-60*PMBWIDTH, BaseInformationLab.bottom-5*PMBWIDTH, 50*PMBWIDTH, 30*PMBWIDTH);
    [_SelctedBtn setImage:[UIImage imageNamed:@"jinru_btn"] forState:UIControlStateNormal];
    [self addSubview:_SelctedBtn];
    
    DynamicInformationLab = [[UILabel alloc]initWithFrame:CGRectMake(BaseInformationLab.left, BaseInformationLab.bottom+15*PMBWIDTH, BaseInformationLab.width, 15*PMBWIDTH)];
    DynamicInformationLab.textColor = TSEColor(180, 180, 180);
    DynamicInformationLab.font = Font(15);
    [self addSubview:DynamicInformationLab];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *array = _model.topic;
    if (array.count>0) {
        PartnerTopic *topic = array[0];
        NSArray *array1 = topic.pic;
        if (array1.count==0) {
            DynamicImg.image = [UIImage imageNamed:@"loading_3"];
        }else{
            PartnerPic *parpic =array1[0];
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,parpic.tPicUrl];
            [DynamicImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_3"]];
        }
        BaseInformationLab.text = [NSString stringWithFormat:@"%@  %@%@",topic.tDate,topic.tTopicCity,topic.tTopicAddress];
        DynamicInformationLab.text = [NSString stringWithFormat:@"%@",topic.tTopicContents];
    }
    
}
@end
