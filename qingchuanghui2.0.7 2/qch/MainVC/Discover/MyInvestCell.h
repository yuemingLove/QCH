//
//  MyInvestCell.h
//  qch
//
//  Created by 苏宾 on 16/3/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInvestCell : SWTableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *pImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;


@end
