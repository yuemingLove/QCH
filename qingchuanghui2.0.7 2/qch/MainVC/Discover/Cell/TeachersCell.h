//
//  TeachersCell.h
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconImg;
@property (weak, nonatomic) IBOutlet UILabel *Informationlab;

@property (weak, nonatomic) IBOutlet UILabel *Bestlab;
@property (weak, nonatomic) IBOutlet UILabel *Remarklab;
@end
