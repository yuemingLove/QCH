//
//  ScanLineCell.m
//  qch
//
//  Created by W.兵 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ScanLineCell.h"

@implementation ScanLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(IBAction)openScanLine:(UIButton*)sender{

    if ([self.scanDelegate respondsToSelector:@selector(openScanLine:index:)]) {
        [self.scanDelegate openScanLine:self index:[sender tag]];
    }
}

@end
