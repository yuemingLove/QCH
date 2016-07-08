//
//  MyChatListCell.h
//  qch
//
//  Created by 苏宾 on 16/1/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface MyChatListCell : RCConversationBaseCell

@property (nonatomic,strong) UIImageView *ivAva;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblDetail;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) UILabel *labelTime;

@end
