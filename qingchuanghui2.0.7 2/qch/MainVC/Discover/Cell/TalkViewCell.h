//
//  TalkViewCell.h
//  qch
//
//  Created by 苏宾 on 16/1/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicTalkModel.h"
@class TalkViewCell;

@protocol TalkViewCellDelegate <NSObject>

- (void)deletetalkClick:(TalkViewCell *)cell index:(NSInteger)index;

@end
@interface TalkViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *line;
@property (nonatomic,strong) UILabel *line2;

@property (nonatomic,weak) IBOutlet UIImageView *headImageView;

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;

@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

@property (nonatomic,weak) IBOutlet UILabel *toUserName;

@property (nonatomic,weak)id<TalkViewCellDelegate>talkdelegate;

@property (nonatomic,strong) UIButton *deleteBtn;

-(void)updateData:(DynamicTalkModel*)model;

@end
