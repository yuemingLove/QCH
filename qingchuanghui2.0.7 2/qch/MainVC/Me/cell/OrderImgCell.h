//
//  OrderImgCell.h
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderImgCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *themeLabel;
@property (nonatomic, strong)NSString *guid;

-(void)updateDate:(NSDictionary *)dict;

@end
