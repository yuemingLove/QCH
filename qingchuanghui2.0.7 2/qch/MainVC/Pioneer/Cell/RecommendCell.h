//
//  RecommendCell.h
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *HeadImg;
@property (weak, nonatomic) IBOutlet UILabel *Title;

@property (weak, nonatomic) IBOutlet UILabel *Remark;
@end
