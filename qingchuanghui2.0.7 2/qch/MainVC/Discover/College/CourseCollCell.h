//
//  CourseCollCell.h
//  qch
//
//  Created by W.兵 on 16/4/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCollCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *signBtn;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;

@property (nonatomic,assign) BOOL isSelect;


@end
