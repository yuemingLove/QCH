//
//  MoreJoinCell.m
//  qch
//
//  Created by 苏宾 on 16/2/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MoreJoinCell.h"

@implementation MoreJoinCell

- (void)awakeFromNib {
    
    _line=[[UILabel alloc]initWithFrame:CGRectMake(_label2.left, _label2.bottom+10*PMBWIDTH, SCREEN_WIDTH-10, 1*PMBWIDTH)];
    [_line setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:_line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateFrame:(NSMutableArray*)usePicArray{
    
    NSInteger count=(SCREEN_WIDTH-10*SCREEN_WSCALE)/(35*SCREEN_WSCALE);
    NSLog(@"测试数据：%ld",[usePicArray count]);
    NSInteger index;
    if (count>=[usePicArray count]+1) {
        index=[usePicArray count];
    } else {
        index=count-1;
    }
    
    for (int i = 0; i<index; i++) {
        
        NSDictionary *dict=[usePicArray objectAtIndex:i];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE+35*SCREEN_WSCALE*i, _line.bottom+6*SCREEN_WSCALE, 30*SCREEN_WSCALE, 30*SCREEN_WSCALE)];
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
    _MoreBtn.frame = CGRectMake(10*PMBWIDTH+35*PMBWIDTH*index,_line.bottom+6*PMBWIDTH, 30*PMBWIDTH, 30*PMBWIDTH);
    _MoreBtn.layer.cornerRadius = _MoreBtn.height/2;
    _MoreBtn.layer.masksToBounds = YES;
    [_MoreBtn setImage:[UIImage imageNamed:@"more_project"] forState:UIControlStateNormal];
    
    [self addSubview:_MoreBtn];
}

-(void)selectImageBtn:(UIButton*)sender{
    if ([self.joinDelegate respondsToSelector:@selector(selectImageView:index:)]) {
        [self.joinDelegate selectImageView:self index:[sender tag]];
    }
}


@end
