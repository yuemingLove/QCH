//
//  MyChatViewController.h
//  qch
//
//  Created by 苏宾 on 16/1/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface MyChatViewController : RCConversationViewController

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

//聊天类型
@property (nonatomic,assign) NSInteger type;

@end
