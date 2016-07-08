//
//  TutorDetailCell.h
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorDetailCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *bestLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

-(void)setIntroductionText:(NSString*)text;

@end
