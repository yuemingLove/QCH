//
//  DeductionVoucherCell.h
//  qch
//
//  Created by W.兵 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeductionVoucherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgkImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

- (void)updata:(NSDictionary *)dict;
@end
