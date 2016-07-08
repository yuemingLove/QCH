//
//  MyAccountDetailsCell.h
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyAccountDetailsCellDelegate <NSObject>

- (void)clickTheAccountButton:(NSInteger)tag;

@end
@interface MyAccountDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *currencyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UIImageView *integraImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;// 创业币
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;// 优惠券
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;// 积分
@property (strong, nonatomic)UILabel *currencyNumberLabel;
@property (strong, nonatomic)UILabel *couponNumberLabel;
@property (strong, nonatomic)UILabel *integralNumberLabel;
@property (nonatomic, weak)id<MyAccountDetailsCellDelegate> delegate;

@end
