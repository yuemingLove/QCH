//
//  OrderCell.h
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrder.h"

@interface OrderCell : UITableViewCell

@property (nonatomic,strong) MyOrder *myOrder;

//展开多个活动信息
@property (nonatomic,copy) void (^showMoreTextBlock)(UITableViewCell *currentCell);

//未展开时的高度
+ (CGFloat)cellDefaultHeight:(MyOrder*)myOrder;

//展开后的高度
+ (CGFloat)cellMoreHeight:(MyOrder*)myOrder;

@end
