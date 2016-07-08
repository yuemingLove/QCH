//
//  BestAndDocell.h
//  qch
//
//  Created by 青创汇 on 16/3/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesCell : UITableViewCell

@property (nonatomic,strong) UIView *fristView;
@property (nonatomic,strong) UIView *secordView;
@property (nonatomic,strong) UIView *thirdView;
@property (nonatomic,strong) UIView *fourView;

- (void)updataFrame:(NSDictionary*)dict;
@end
