//
//  QCHambitusVC.h
//  qch
//
//  Created by 青创汇 on 16/1/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"
typedef void (^ReturnTextBlock)(NSString *showText);

@interface QCHambitusVC : QchBaseViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
