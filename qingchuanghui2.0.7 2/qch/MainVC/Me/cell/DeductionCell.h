//
//  DeductionCell.h
//  qch
//
//  Created by 青创汇 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeductionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LeftbackImg;
@property (weak, nonatomic) IBOutlet UIImageView *selsectImage;

@property (weak, nonatomic) IBOutlet UILabel *DeductionLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UILabel *Ramark;
@property (weak, nonatomic) IBOutlet UIImageView *EffectImg;
@property (weak, nonatomic) IBOutlet UILabel *Money;

- (void)updateData:(NSDictionary*)dict;

@end
