//
//  MoreBtnCell.m
//  qch
//
//  Created by 苏宾 on 16/1/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MoreBtnCell.h"

@implementation MoreBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}
- (void)_initView{
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1*PMBWIDTH)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line];
    
    UIButton *moreBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, SCREEN_WIDTH, 28*PMBWIDTH)];
    [moreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font=Font(14);
    [moreBtn addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    
}

-(void)loadMore:(UIButton*)sender{
    if ([self.moreDelegate respondsToSelector:@selector(CommentList:)]) {
        [self.moreDelegate CommentList:self];
    }
}

@end
