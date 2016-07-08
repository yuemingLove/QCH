//
//  HttpRCDAction.m
//  qch
//
//  Created by 苏宾 on 16/1/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpRCDAction.h"

@implementation HttpRCDAction

+ (void)createDiscussion:(NSString *)name
              userIdList:(NSArray *)userIdList
                complete:(HttpRCDBlock)block{
    [[RCIMClient sharedRCIMClient] createDiscussion:name userIdList:userIdList success:^(RCDiscussion *discussion) {
        block(discussion,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

+ (void)addNumberToDiscussion:(NSString *)discussionId userIdList:(NSArray *)userIdList complete:(HttpRCDBlock)block{
    [[RCIMClient sharedRCIMClient] addMemberToDiscussion:discussionId userIdList:userIdList success:^(RCDiscussion *discussion) {
        block(discussion,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

+ (void)removeNumberFromDiscussion:(NSString *)discussionId userId:(NSString *)userId complete:(HttpRCDBlock)block{
    [[RCIMClient sharedRCIMClient] removeMemberFromDiscussion:discussionId userId:userId success:^(RCDiscussion *discussion) {
        block(discussion,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

+ (void)quitDiscussion:(NSString *)discussionId complete:(HttpRCDBlock)block{

    [[RCIMClient sharedRCIMClient]quitDiscussion:discussionId success:^(RCDiscussion *discussion) {
        block(discussion,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

+ (void)getDiscussion:(NSString *)discussionId complete:(HttpRCDBlock)block{
    [[RCIMClient sharedRCIMClient]getDiscussion:discussionId success:^(RCDiscussion *discussion) {
        block(discussion,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

+ (void)setDiscussionName:(NSString *)targetId name:(NSString *)discussionName complete:(HttpRCDBlock)block{
    [[RCIMClient sharedRCIMClient]setDiscussionName:targetId name:discussionName success:^{
        block(nil,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

+ (void)setDiscussionInviteStatus:(NSString *)targetId isOpen:(BOOL)isOpen complete:(HttpRCDBlock)block{
    [[RCIMClient sharedRCIMClient]setDiscussionInviteStatus:targetId isOpen:isOpen success:^{
        block(nil,nil);
    } error:^(RCErrorCode status) {
        block(nil,status);
    }];
}

@end
