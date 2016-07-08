//
//  MyOrderFirstCell.h
//  qch
//
//  Created by W.兵 on 16/6/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *publicProgramsImage;
@property (weak, nonatomic) IBOutlet UILabel *publicProgramsLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic, copy) void(^orderBlock)();
-(void)updateDate:(NSDictionary*)dict;

@end
