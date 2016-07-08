//
//  ProjectStatusCell.m
//  qch
//
//  Created by 苏宾 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectStatusCell.h"

@implementation ProjectStatusCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-5, SCREEN_WIDTH, 5)]
    ;
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(IBAction)SetUserStyle:(id)sender{
    if ([self.projectDelegate respondsToSelector:@selector(setUserStyle:)]) {
        [self.projectDelegate setUserStyle:self];
    }
}

@end
