//
//  CourseListCell.h
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UIImageView *signImageView;

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *longTimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *scanCountLabel;
@property (nonatomic,weak) IBOutlet UILabel *dateLabel;

-(void)updateFrame:(NSDictionary*)dict;

@end
