//
//  ThemeCell.m
//  qch
//
//  Created by 苏宾 on 16/1/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}
- (void)_initView{
    
    UILabel *themeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WHCALE, 80*SCREEN_WSCALE, 18*SCREEN_WHCALE)];
    [themeLabel setText:@"最新评论"];
    [themeLabel setTextColor:[UIColor blackColor]];
    themeLabel.font=Font(15);
    [self addSubview:themeLabel];
    
}


@end
