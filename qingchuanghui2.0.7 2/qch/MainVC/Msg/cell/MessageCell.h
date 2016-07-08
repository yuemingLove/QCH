//
//  MessageCell.h
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *typeLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

-(void)setIntroductionText:(NSString*)text;

@end
