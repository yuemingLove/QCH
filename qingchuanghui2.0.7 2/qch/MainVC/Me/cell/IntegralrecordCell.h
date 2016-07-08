//
//  IntegralrecordCell.h
//  qch
//
//  Created by 青创汇 on 16/6/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralrecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *Integarl;
@property (weak, nonatomic) IBOutlet UIImageView *BackImg;
@property (weak, nonatomic) IBOutlet UILabel *Record;
@property (weak, nonatomic) IBOutlet UILabel *Remark;

- (void)updata:(NSDictionary*)dict;
@end
