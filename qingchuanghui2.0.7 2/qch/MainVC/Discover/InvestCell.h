//
//  InvestCell.h
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestCell : UITableViewCell

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) UIView *fristView;
@property (nonatomic,strong) UIView *secordView;
@property (nonatomic,strong) UIView *thridView;

- (void)updateFrame:(NSDictionary*)dict;

-(void)setFrameHeight:(NSDictionary*)dict;

@end
