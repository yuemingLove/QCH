//
//  TeacherCell.h
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IconImg;

@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *Remark;
@property (weak, nonatomic) IBOutlet UIButton *selectbtn;

@property (nonatomic,assign) BOOL isSelect;

@end
