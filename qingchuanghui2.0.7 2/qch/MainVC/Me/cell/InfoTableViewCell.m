//
//  InfoTableViewCell.m
//  Jpbbo
//
//  Created by jpbbo on 15/7/9.
//  Copyright (c) 2015年 河南金马电子商务股份有限公司. All rights reserved.
//

#import "InfoTableViewCell.h"


@interface InfoTableViewCell ()<UITextFieldDelegate>

@end

@implementation InfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(userInfoEditCellShouldBeginEidting:)]) {
        return [_delegate userInfoEditCellShouldBeginEidting:self];
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(userInfoEditCellDidEndEditing:)]) {
        [_delegate userInfoEditCellDidEndEditing:self];
    }
}

@end
