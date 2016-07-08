//
//  DeductionVC2.h
//  qch
//
//  Created by W.兵 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface DeductionVC2 : QchBaseViewController

@property (nonatomic, copy)void(^couponBlock)(NSDictionary*dic, NSIndexPath *index);
@property (nonatomic, strong)NSIndexPath *index;

@end
