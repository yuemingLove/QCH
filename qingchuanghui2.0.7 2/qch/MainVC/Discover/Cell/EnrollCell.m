//
//  EnrollCell.m
//  qingchuanghui
//
//  Created by 青创汇 on 15/12/26.
//  Copyright © 2015年 SOLOLI. All rights reserved.
//

#import "EnrollCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation EnrollCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}
- (void)_initView{
    
    _EnrollTxt =[[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*PMBWIDTH, 42*SCREEN_WSCALE, 14*PMBWIDTH)];
    _EnrollTxt.textColor=[UIColor blackColor];
    _EnrollTxt.textAlignment=NSTextAlignmentRight;
    _EnrollTxt.font=Font(14);
    _EnrollTxt.text=@"已报名";
    [self addSubview:_EnrollTxt];
    
    _EnrollNum=[[UILabel alloc]initWithFrame:CGRectMake(_EnrollTxt.right, _EnrollTxt.top, 60*SCREEN_WSCALE, _EnrollTxt.height)];
    _EnrollNum.font=Font(14);
    _EnrollNum.textAlignment=NSTextAlignmentCenter;
    _EnrollNum.textColor=[UIColor blueColor];
    [self addSubview:_EnrollNum];
    
    _Enrolllab = [[UILabel alloc]initWithFrame:CGRectMake(_EnrollNum.right, _EnrollTxt.top, 20*PMBWIDTH, _EnrollTxt.height)];
    _Enrolllab.textColor = [UIColor blackColor];
    _Enrolllab.textAlignment=NSTextAlignmentLeft;
    _Enrolllab.font = Font(14.0f);
    _Enrolllab.text = @"人";
    [self addSubview:_Enrolllab];
    
    hengxianlab   = [[UILabel alloc]initWithFrame:CGRectMake(0, _Enrolllab.bottom+8*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    hengxianlab.backgroundColor = [UIColor themeGrayColor];
    [self addSubview:hengxianlab];
    
    
}

-(void)updateFrame:(NSMutableArray*)usePicArray{
    
    for (int i = 0; i<[usePicArray count]; i++) {
        
        NSDictionary *dict=[usePicArray objectAtIndex:i];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH+35*PMBWIDTH*i, hengxianlab.bottom+8*PMBWIDTH, 30*PMBWIDTH, 30*PMBWIDTH)];
        image.layer.cornerRadius = image.height/2;
        image.layer.masksToBounds = YES;
        
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"ApplyUserPic"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];

        [self addSubview:image];
        

        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=image.frame;
        button.tag=i;
        [button addTarget:self action:@selector(selectImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    _MoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _MoreBtn.frame = CGRectMake(5*PMBWIDTH+35*PMBWIDTH*[usePicArray count]+5*PMBWIDTH,hengxianlab.bottom+8*PMBWIDTH, 30*PMBWIDTH, 30*PMBWIDTH);
    _MoreBtn.layer.cornerRadius = _MoreBtn.height/2;
    _MoreBtn.layer.masksToBounds = YES;
    [_MoreBtn setImage:[UIImage imageNamed:@"hd_more_btn"] forState:UIControlStateNormal];

    [self addSubview:_MoreBtn];
    
//    UILabel *line   = [[UILabel alloc]initWithFrame:CGRectMake(0, _MoreBtn.bottom+8*PMBHEIGHT, ScreenWidth, 1*PMBHEIGHT)];
//    line.backgroundColor = [UIColor themeGrayColor];
//    [self addSubview:line];
}

-(void)selectImageBtn:(UIButton*)sender{
    if ([self.enrollDelegate respondsToSelector:@selector(selectImageView:index:)]) {
        [self.enrollDelegate selectImageView:self index:[sender tag]];
    }
}



@end
