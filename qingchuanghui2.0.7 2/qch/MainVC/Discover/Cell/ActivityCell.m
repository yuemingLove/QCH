//
//  ActivityCell.m
//  qingchuanghui
//
//  Created by 青创汇 on 15/12/25.
//  Copyright © 2015年 SOLOLI. All rights reserved.
//

#import "ActivityCell.h"
#import "UIImageView+WebCache.h"

@implementation ActivityCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}
- (void)_initView{
    
    self.backgroundColor = [UIColor whiteColor];
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 15*PMBWIDTH, 100*PMBWIDTH, 80*PMBWIDTH)];
    imageview.image = [UIImage imageNamed:@"zwt_cyzx_img"];
    [self addSubview:imageview];
    
    
    titlelab = [[UILabel alloc]initWithFrame:CGRectMake(imageview.right+10*PMBWIDTH, imageview.top, SCREEN_WIDTH-imageview.width-30*PMBWIDTH, 36*PMBWIDTH)];
    titlelab.lineBreakMode = NSLineBreakByCharWrapping;
    titlelab.numberOfLines = 2;
    titlelab.text = @"你是开发难受123312312313123213";
    titlelab.font = Font(15.0f);
    [self addSubview:titlelab];
    
    statelab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60*SCREEN_WSCALE, imageview.bottom-13*PMBWIDTH, 50*SCREEN_WSCALE, 13*PMBWIDTH)];
    statelab.textAlignment=NSTextAlignmentLeft;
    statelab.text=@"已结束";
    statelab.textColor=[UIColor lightGrayColor];
    statelab.font = Font(12.0f);
    [self addSubview:statelab];
    
    numPreson=[[UILabel alloc]initWithFrame:CGRectMake(statelab.left-30*SCREEN_WSCALE, statelab.top, 30*SCREEN_WSCALE, statelab.height)];
    numPreson.textAlignment=NSTextAlignmentRight;
    numPreson.text=@"5";
    numPreson.textColor=[UIColor themeBlueTwoColor];
    numPreson.font = Font(12.0f);
    [self addSubview:numPreson];
    
    UIImageView *locview = [[UIImageView alloc]initWithFrame:CGRectMake(titlelab.left, statelab.top-20*PMBWIDTH, 14*PMBWIDTH, 14*PMBWIDTH)];
    locview.image = [UIImage imageNamed:@"icon_location"];
    [self addSubview:locview];
    
    
    locLab = [[UILabel alloc]initWithFrame:CGRectMake(locview.right+2*PMBWIDTH, locview.top+2*PMBWIDTH, 50*PMBWIDTH, 12*PMBWIDTH)];
    locLab.font = Font(12.0f);
    locLab.text = @"郑州";
    locLab.textColor = [UIColor lightGrayColor];
    [self addSubview:locLab];
    
    
    UIImageView *timeimg = [[UIImageView alloc]initWithFrame:CGRectMake(locLab.right, locLab.top, 14*PMBWIDTH, 14*PMBWIDTH)];
    timeimg.image = [UIImage imageNamed:@"lunch_time"];
    [self addSubview:timeimg];
    
    
    timelab = [[UILabel alloc]initWithFrame:CGRectMake(timeimg.right+2*PMBWIDTH, locview.top+2*PMBWIDTH, 130*PMBWIDTH, 12*PMBWIDTH)];
    timelab.font = Font(12.0f);
    timelab.textColor = [UIColor lightGrayColor];
    timelab.text = @"12/08";
    [self addSubview:timelab];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

-(void)updateData:(PActivityModel *)dict{
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,dict.t_Activity_CoverPic];
    [imageview sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_3"]];
    
    [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageview.contentMode =  UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds  = YES;
    
    titlelab.text=dict.t_Activity_Title;
    locLab.text=dict.t_Activity_CityName;
    NSString *time=dict.t_Activity_sDate;
    time=[time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    time=[time substringFromIndex:5];
    time=[time substringToIndex:11];
    timelab.text=time;
    
    if ([dict.ifOver isEqualToString:@"1"]) {
        
        numPreson.text=@"";
        statelab.text=@"已结束";
    } else {
        numPreson.text=dict.ApplyCount;
        statelab.text=@"人已报名";
    }
    
}

@end
