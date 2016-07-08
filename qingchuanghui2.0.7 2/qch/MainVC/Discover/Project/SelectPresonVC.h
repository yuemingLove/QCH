//
//  SelectPresonVC.h
//  qch
//
//  Created by W.兵 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"
typedef void (^ReturnArrayblock)(NSMutableArray*Array);

@interface SelectPresonVC : QchBaseViewController

@property (nonatomic,copy)ReturnArrayblock returnArray;

@property (nonatomic,strong) NSMutableArray *selectArray;

- (void)returnArray:(ReturnArrayblock)block;

@end
