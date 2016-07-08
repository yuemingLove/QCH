//
//  HttpRCDAction.h
//  qch
//
//  Created by 苏宾 on 16/1/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpRCDBlock)(id result,RCErrorCode *error);

@interface HttpRCDAction : NSObject

/*!
 创建讨论组
 
 @param name                        讨论组名称
 @param userIdList                  用户ID的列表
 @param successBlock                创建讨论组成功的回调
 @param discussion(in successBlock) 创建成功返回的讨论组对象
 @param errorBlock                  创建讨论组失败的回调
 @param status(in errorBlock)       创建失败的错误码
 */
+ (void)createDiscussion:(NSString *)name
              userIdList:(NSArray *)userIdList
                 complete:(HttpRCDBlock)block;

/*!
 加入讨论组
 @param discussionId                        讨论组ID
 @param userIdList                  用户ID的列表
 @param block                创建讨论组成功的回调
 @param status(in errorBlock)       创建失败的错误码
 */
+ (void)addNumberToDiscussion:(NSString *)discussionId userIdList:(NSArray *)userIdList complete:(HttpRCDBlock)block;

/*!
 删除用户
 @param discussionId            讨论组ID
 @param userId                  用户ID
 @param block                创建讨论组成功的回调
 @param status(in errorBlock)       创建失败的错误码
 */
+ (void)removeNumberFromDiscussion:(NSString *)discussionId userId:(NSString *)userId complete:(HttpRCDBlock)block;

/*!
 退出讨论组
 @param discussionId            讨论组ID
 @param block                创建讨论组成功的回调
 @param status(in errorBlock)       创建失败的错误码
 */
+ (void)quitDiscussion:(NSString *)discussionId complete:(HttpRCDBlock)block;

/*!
 获取讨论组信息
 @param discussionId            讨论组ID
 @param block                创建讨论组成功的回调
 @param status(in errorBlock)       创建失败的错误码
 */
+ (void)getDiscussion:(NSString *)discussionId complete:(HttpRCDBlock)block;

/*!
 设置讨论组名称
 
 @param targetId                需要设置的讨论组ID
 @param discussionName          需要设置的讨论组名称，discussionName长度<=40
 @param block              设置回调
 @param status(in errorBlock)   设置失败的错误码
 
 @discussion 设置的讨论组名称长度不能超过40个字符，否则将会截断为前40个字符。
 */
+ (void)setDiscussionName:(NSString *)targetId name:(NSString *)discussionName complete:(HttpRCDBlock)block;


/*!
 设置讨论组是否开放加人权限
 
 @param targetId                    讨论组ID
 @param isOpen                      是否开放加人权限
 @param block 设置成功的回调
 @param errorBlock                  设置失败的回调
 @param status(in errorBlock)       设置失败的错误码
 
 @discussion 讨论组默认开放加人权限，即所有成员都可以加人。
 如果关闭加人权限之后，只有讨论组的创建者有加人权限。
 */
+ (void)setDiscussionInviteStatus:(NSString *)targetId isOpen:(BOOL)isOpen complete:(HttpRCDBlock)block;

@end
