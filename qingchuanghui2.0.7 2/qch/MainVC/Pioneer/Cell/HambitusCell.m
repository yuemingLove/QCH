//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "HambitusCell.h"

@implementation HambitusCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        _imageView.tag = self.tag;
        self.clipsToBounds = YES;
        
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.width-15*PMBWIDTH, 0, 15*PMBWIDTH, 15*SCREEN_WSCALE);
        [_deleteBtn setImage:[UIImage imageNamed:@"dongtai_zpsc_btn"] forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor lightGrayColor];
        _deleteBtn.layer.cornerRadius = _deleteBtn.height/2;
        _deleteBtn.tag = self.tag;
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}
- (void)tapImage:(UILongPressGestureRecognizer *)longtap
{
    if ([self.hmdelegate respondsToSelector:@selector(longtapImagewithObject:longtap:)]) {
        [self.hmdelegate longtapImagewithObject:self longtap:longtap];
    }
    
}

@end
