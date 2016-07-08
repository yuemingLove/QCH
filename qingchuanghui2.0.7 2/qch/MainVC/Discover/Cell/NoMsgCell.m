//
//  NoMsgCell.m
//  qch
//
//  Created by 苏宾 on 16/1/30.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "NoMsgCell.h"

@implementation NoMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}

- (void)_initView{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36*PMBWIDTH)];
    label.text=@"暂无评论";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor lightGrayColor];
    label.font=Font(14);
    [self addSubview:label];
}

@end
