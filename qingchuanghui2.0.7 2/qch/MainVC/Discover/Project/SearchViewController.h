//
//  SearchViewController.h
//  qch
//
//  Created by 青创汇 on 16/5/5.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

typedef void (^ReturnStringBlock)(NSString *SearchString);

@interface SearchViewController : QchBaseViewController

@property (nonatomic,copy)ReturnStringBlock returnstringblock;

- (void)returnString:(ReturnStringBlock)block;

@end
