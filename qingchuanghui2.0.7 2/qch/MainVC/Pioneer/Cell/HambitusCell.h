//
//  TZTestCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HambitusCell;

@protocol HambitusCellDelegate <NSObject>

- (void)longtapImagewithObject:(HambitusCell *)cell longtap:(UILongPressGestureRecognizer *)longtap;

@end

@interface HambitusCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton * deleteBtn;


@property (nonatomic,weak) id<HambitusCellDelegate>hmdelegate;

@end