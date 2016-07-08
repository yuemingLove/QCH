//
//  CourseCell.h
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrowdfundingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LogoImg;
@property (weak, nonatomic) IBOutlet UILabel *Information;
@property (weak, nonatomic) IBOutlet UILabel *Time;

@property (weak, nonatomic) IBOutlet UIProgressView *Progress;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *Support;
@property (weak, nonatomic) IBOutlet UIButton *Supportbtn;

- (void)updataframe:(NSDictionary *)dict;
@end
