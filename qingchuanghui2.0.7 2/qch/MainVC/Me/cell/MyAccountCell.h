//
//  MyAccountCell.h
//  qch
//
//  Created by 苏宾 on 16/3/21.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *typeLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

@property (nonatomic,weak) IBOutlet UIImageView *blockImageView;
@property (nonatomic,weak) IBOutlet UIView *bgkView;


@end
