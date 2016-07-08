//
//  HotCityCell.h
//  qch
//
//  Created by 苏宾 on 16/3/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCityCell : UITableViewCell

@property (nonatomic,copy) void (^buttonClickBlock)(UIButton *);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray*)cities;

- (void)buttonWhenClick:(void(^)(UIButton *button))block;


@end
